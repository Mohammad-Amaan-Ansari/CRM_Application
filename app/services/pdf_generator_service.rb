# frozen_string_literal: true

require 'prawn'

class PdfGeneratorService
  MONTSERRAT_FONT_PATH = Rails.root.join('app/assets/fonts/Montserrat-Medium.ttf')
  MONTSERRAT_BOLD_FONT_PATH = Rails.root.join('app/assets/fonts/Montserrat-Black.ttf')
  ICON_IMG_PATH = Rails.root.join('app/assets/images/app_icon.png')

  def initialize(order)
    @order = order
    @pdf = Prawn::Document.new
    @document_width = @pdf.bounds.width
    @pdf.font_families.update(
      'montserrat' => {
        normal: MONTSERRAT_FONT_PATH,
        bold: MONTSERRAT_BOLD_FONT_PATH
      }
    )
    @pdf.font 'montserrat'
  end

  def header
    @pdf.bounding_box([0, @pdf.cursor], width: @document_width, height: 150) do
      # Background Color
      @pdf.fill_color '0c40df' # Background color
      @pdf.rectangle([0, @pdf.cursor], @document_width, 150)
      @pdf.fill_and_stroke

      # Invoice Heading
      @pdf.fill_color 'ffffff'
      @pdf.font_size(24)
      @pdf.text 'Invoice', align: :left, valign: :top
      @pdf.image ICON_IMG_PATH, at: [6, @pdf.cursor - 10], width: 100

      # Company Information
      @pdf.bounding_box([@document_width - 200, @pdf.cursor], width: 200, height: 150) do
        @pdf.text 'Shadbox Pvt Ltd', size: 12, style: :bold, color: 'ffffff'
        @pdf.text 'Jafar Nagar, Nagpur 440018', size: 10, color: 'ffffff'
        @pdf.text 'Phone: 1234567890', size: 10, color: 'ffffff'
        @pdf.text "Email: #{admin_email}", size: 10, color: 'ffffff'
      end

      @pdf.move_down 20
    end
  end

  def upper_mid_section
    @pdf.bounding_box([0, @pdf.cursor], width: @document_width, height: 100) do
      # Background Color
      @pdf.fill_color 'ffffff' # White background
      @pdf.rectangle([0, @pdf.cursor], @document_width, 100)
      @pdf.fill_and_stroke

      # Invoice Details
      @pdf.bounding_box([6, @pdf.cursor - 10], width: @document_width / 2) do
        @pdf.font_size(12)
        @pdf.text 'Invoice Details:', size: 12, style: :bold, color: '000000'
        @pdf.text "Invoice No: #{generate_invoice_number}", size: 10, color: '000000'
        @pdf.text "Date of Issue: #{Date.today.strftime('%d-%m-%Y')}", size: 10, color: '000000'
      end

      # User Details
      @pdf.bounding_box([@document_width / 2, @pdf.cursor + 40], width: @document_width / 2) do
        @pdf.font_size(12)
        @pdf.text 'User Details:', size: 12, style: :bold, color: '000000'
        @pdf.text "Email: #{@order.user.email}", size: 10, color: '000000'
        @pdf.text "Total Products: #{@order.products.count}", size: 10, color: '000000'
      end

      @pdf.move_down 20
    end
  end

  def lower_mid_section
    @pdf.move_down 20

    # Product Listing Header
    product_list_header = [['Category', 'Product', 'P_SKU', 'Product Size', 'Price']]

    # Product Listing Data
    product_list = @order.products.map do |product|
      [
        product.category&.c_name || 'N/A',
        product.name || 'N/A',
        product.sku || 'N/A',
        product.size || 'N/A',
        format_currency(product.price)
      ]
    end

    product_table_data = product_list_header + product_list

    # Product Table Options
    # Product Table Options with only white rows
    product_table_options = {
      width: @document_width,
      row_colors: ['ffffff'], # Only white background for all rows
      cell_style: {
        border_width: 1,
        borders: [:bottom],
        border_color: '000000',
        padding: [8, 8],
        size: 10,
        font: 'montserrat'
      }
    }

    # Render Product Table
    # Render Product Table
    @pdf.table(product_table_data, product_table_options) do |table|
      table.row(0).font_style = :bold
      table.row(0).text_color = '000000' # Header row text color
      table.row(0).size = 12
      table.row(1..-1).column(1..-1).align = :center
      table.row(1..-1).size = 10
      table.row(1..-1).text_color = '000000' # Ensure all rows have black text
    end

    @pdf.move_down 20
  end

  def result_section
    @pdf.move_down 20

    # Subtotal
    subtotal = @order.products.sum(&:price)

    # Discount, Tax, and Total Amount
    discount = subtotal * 0.05
    tax = (subtotal - discount) * 0.18
    total_amount = subtotal - discount + tax

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
      table.row(0..-1).font_style = :bold
      table.row(0..-1).background_color = 'f0f0f0'
      table.row(0..-1).padding = [5, 10]
      table.row(0..-1).text_color = '333333'
    end
  end

  def footer
    @pdf.move_down 20
    @pdf.text 'Thank you for your business!', size: 12, style: :bold, color: '333333', align: :center
    @pdf.text 'We hope to serve you again!', size: 10, color: '666666', align: :center
  end

  def generate_pdf
    header
    upper_mid_section
    lower_mid_section
    result_section
    footer
    @pdf.render
  end

  private

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
