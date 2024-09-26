# frozen_string_literal: true

# app/services/pdf_generator_service.rb
class PdfGeneratorService
  MONTSERRAT_FONT_PATH = Rails.root.join('app/assets/fonts/Montserrat-Medium.ttf')
  MONTSERRAT_BOLD_FONT_PATH = Rails.root.join('app/assets/fonts/Montserrat-Black.ttf')
  ICON_IMG_PATH = Rails.root.join('app/assets/images/app_icon.png')

  def initialize(order)
    @order = order
    @pdf = Prawn::Document.new
    @document_width = @pdf.bounds.width
    setup_fonts
  end

  def generate_pdf
    header
    upper_mid_section
    product_table
    result_section
    footer
    @pdf.render
  end

  private

  # Set up fonts
  def setup_fonts
    @pdf.font_families.update(
      'montserrat' => {
        normal: MONTSERRAT_FONT_PATH,
        bold: MONTSERRAT_BOLD_FONT_PATH
      }
    )
    @pdf.font 'montserrat'
  end

  # Header Section
  def header
    @pdf.bounding_box([0, @pdf.cursor], width: @document_width, height: 150) do
      draw_header_background
      invoice_heading
      company_info
      @pdf.move_down 20
    end
  end

  def draw_header_background
    @pdf.fill_color '0c40df'
    @pdf.rectangle([0, @pdf.cursor], @document_width, 150)
    @pdf.fill_and_stroke
  end

  def invoice_heading
    @pdf.fill_color 'ffffff'
    @pdf.font_size(24)
    @pdf.text 'Invoice', align: :left, valign: :top
    @pdf.image ICON_IMG_PATH, at: [6, @pdf.cursor - 10], width: 100
  end

  def company_info
    @pdf.bounding_box([@document_width - 200, @pdf.cursor], width: 200, height: 150) do
      @pdf.text 'Shadbox Pvt Ltd', size: 12, style: :bold, color: 'ffffff'
      @pdf.text 'Jafar Nagar, Nagpur 440018', size: 10, color: 'ffffff'
      @pdf.text 'Phone: 1234567890', size: 10, color: 'ffffff'
      @pdf.text "Email: #{admin_email}", size: 10, color: 'ffffff'
    end
  end

  # Upper Mid Section
  def upper_mid_section
    @pdf.bounding_box([0, @pdf.cursor], width: @document_width, height: 100) do
      draw_upper_mid_background
      invoice_details
      user_details
      @pdf.move_down 20
    end
  end

  def draw_upper_mid_background
    @pdf.fill_color 'ffffff'
    @pdf.rectangle([0, @pdf.cursor], @document_width, 100)
    @pdf.fill_and_stroke
  end

  def invoice_details
    @pdf.bounding_box([6, @pdf.cursor - 10], width: @document_width / 2) do
      @pdf.font_size(12)
      @pdf.text 'Invoice Details:', size: 12, style: :bold, color: '000000'
      @pdf.text "Invoice No: #{generate_invoice_number}", size: 10, color: '000000'
      @pdf.text "Date of Issue: #{Date.today.strftime('%d-%m-%Y')}", size: 10, color: '000000'
    end
  end

  def user_details
    @pdf.bounding_box([@document_width / 2, @pdf.cursor + 40], width: @document_width / 2) do
      @pdf.font_size(12)
      @pdf.text 'User Details:', size: 12, style: :bold, color: '000000'
      @pdf.text "Email: #{@order.user.email}", size: 10, color: '000000'
      @pdf.text "Total Products: #{@order.products.count}", size: 10, color: '000000'
    end
  end

  # Product Table
  def product_table
    @pdf.move_down 20
    product_list_header = [['Category', 'Product', 'P_SKU', 'Product Size', 'Price']]
    product_table_data = product_list_header + product_rows

    product_table_options = {
      width: @document_width,
      row_colors: ['ffffff'],
      cell_style: {
        border_width: 1,
        borders: [:bottom],
        border_color: '000000',
        padding: [8, 8],
        size: 10,
        font: 'montserrat'
      }
    }

    @pdf.table(product_table_data, product_table_options) do |table|
      style_product_table(table)
    end

    @pdf.move_down 20
  end

  def product_rows
    @order.products.map do |product|
      [
        product.category&.c_name || 'N/A',
        product.name || 'N/A',
        product.sku || 'N/A',
        product.size || 'N/A',
        format_currency(product.price)
      ]
    end
  end

  def style_product_table(table)
    table.row(0).font_style = :bold
    table.row(0).text_color = '000000'
    table.row(0).size = 12
    table.row(1..-1).column(1..-1).align = :center
    table.row(1..-1).size = 10
    table.row(1..-1).text_color = '000000'
  end

  # Result Section
  def result_section
    @pdf.move_down 20

    result_data = [
      ['Subtotal:', '', format_currency(subtotal)],
      ['Discount (5%):', '', format_currency(-discount)],
      ['Tax (18%):', '', format_currency(tax)],
      ['Total Amount:', '', format_currency(total_amount)]
    ]

    result_data_options = {
      width: @document_width,
      cell_style: {
        border_width: 0,
        padding: [5, 5],
        size: 10,
        font: 'montserrat',
        text_color: '333333'
      }
    }

    @pdf.table(result_data, result_data_options) do |table|
      style_result_table(table)
    end
  end

  def style_result_table(table)
    table.row(0..-1).font_style = :bold
    table.row(0..-1).background_color = 'f0f0f0'
    table.row(0..-1).padding = [5, 10]
    table.row(0..-1).text_color = '333333'
  end

  def subtotal
    @order.products.sum(&:price)
  end

  def discount
    subtotal * 0.05
  end

  def tax
    (subtotal - discount) * 0.18
  end

  def total_amount
    subtotal - discount + tax
  end

  # Footer
  def footer
    @pdf.move_down 20
    @pdf.text 'Thank you for your business!', size: 12, style: :bold, color: '333333', align: :center
    @pdf.text 'We hope to serve you again!', size: 10, color: '666666', align: :center
  end

  # Helpers
  def format_currency(amount)
    format('₹%.2f', amount)
  end

  def generate_invoice_number
    "INV-#{SecureRandom.hex(4).upcase}"
  end

  def admin_email
    admin = User.find_by(role: 'admin')
    admin.email
  end
end
