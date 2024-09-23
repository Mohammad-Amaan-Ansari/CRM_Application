# frozen_string_literal: true
key
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
New Task

add pagination
style image ui

# # # # # # #   # app/controllers/orders_controller.rb
# # # # # # #   # def generate_invoice
# # # # # # #   # 	order = Order.find(params[:id])
# # # # # # #   # 	PdfGenerator.generate_invoice(order)
# # # # # # #   # 	redirect_to order_path(order), notice: 'Invoice generated successfully.'
# # # # # # #   # end

# # # # # # #   # def set_user
# # # # # # #   #   @user = User.find(params[:user_id])
# # # # # # #   # end

# # # # # # #   class OrdersController < ApplicationController
# # # # # # #   before_action :authenticate_user!

# # # # # # #   def index
# # # # # # #     @orders = Order.all
# # # # # # #   end

# # # # # # #   def show
# # # # # # #     @order = Order.find(params[:id])
# # # # # # #   end

# # # # # # #   def new
# # # # # # #     @order = Order.new
# # # # # # #   end

# # # # # # #   def create
# # # # # # #    @order = current_user.orders.build(order_params)
# # # # # # #     if @order.save
# # # # # # #       redirect_to orders_path, notice: 'Order was successfully created.'
# # # # # # #     else
# # # # # # #       render :new
# # # # # # #     end
# # # # # # #   end

# # # # # # #   def edit
# # # # # # #     @order = Order.find(params[:id])
# # # # # # #   end

# # # # # # #   def update
# # # # # # #     @order = Order.find(params[:id])
# # # # # # #     if @order.update(order_params)
# # # # # # #       redirect_to @order, notice: 'Order was successfully updated.'
# # # # # # #     else
# # # # # # #       render :edit
# # # # # # #     end
# # # # # # #   end

# # # # # # #   def destroy
# # # # # # #     @order = Order.find(params[:id])
# # # # # # #     @order.destroy
# # # # # # #     redirect_to orders_url, notice: 'Order was successfully destroyed.'
# # # # # # #   end

# # # # # # #   def generate_pdf
# # # # # # #     order = Order.find(params[:id])
# # # # # # #     pdf_service = PdfGeneratorService.new(order)
# # # # # # #     pdf_content = pdf_service.generate_pdf
# # # # # # #     pdf_filename = "invoice_#{order.id}.pdf"

# # # # # # #     respond_to do |format|
# # # # # # #       format.pdf do
# # # # # # #         send_data pdf_content, filename: pdf_filename, type: 'application/pdf', disposition: 'attachment'
# # # # # # #       end
# # # # # # #     end
# # # # # # #   end

# # # # # # #   private

# # # # # # #   def order_params
# # # # # # #     params.require(:order).permit(:order_no, :total_amount, :invoice, :product_id, :user_id)
# # # # # # #   end
# # # # # # # end

# # # # # # class PdfGeneratorService
# # # # # #     MONTSERRAT_FONT_PATH = 'app/assets/stylesheets/Montserrat-Medium.ttf'
# # # # # #     MONTSERRAT_BOLD_FONT_PATH = 'app/assets/stylesheets/Montserrat-Black.ttf'
# # # # # #     ICON_IMG_PATH = 'app/assets/images/app_icon.png' # Assuming you have an icon

# # # # # #     def initialize(order)
# # # # # #         @order = order
# # # # # #         @pdf = Prawn::Document.new
# # # # # #         @document_width = @pdf.bounds.width
# # # # # #         @pdf.font_families.update(
# # # # # #             'montserrat' => {
# # # # # #                 normal: MONTSERRAT_FONT_PATH,
# # # # # #                 bold: MONTSERRAT_BOLD_FONT_PATH
# # # # # #             }
# # # # # #         )
# # # # # #     end

# # # # # #     def header
# # # # # #         # Order Summary
# # # # # #         header_column_widths = [@document_width * 2 / 3, @document_width * 1 / 3]
# # # # # #         header_title_data = [['Order Summary']]
# # # # # #         header_title_options = {
# # # # # #             column_widths: [@document_width],
# # # # # #             row_colors: ['EDEFF5'],
# # # # # #             cell_style: {
# # # # # #                 border_width: 0,
# # # # # #                 padding: [8, 6, 0, 10],  # Adjust padding to reduce space
# # # # # #                 size: 16,  # Reduced text size
# # # # # #                 font: 'montserrat',
# # # # # #                 font_style: :normal
# # # # # #             }
# # # # # #         }

# # # # # #         header_icon_data = [[header_title_data, { image: ICON_IMG_PATH, position: :center, scale: 0.1, colspan: 2 }]]  # Reduced icon scale
# # # # # #         header_icon_options = {
# # # # # #             column_widths: header_column_widths,
# # # # # #             row_colors: ['EDEFF5'],
# # # # # #             cell_style: {
# # # # # #                 border_width: 2,
# # # # # #                 padding: [8, 8],  # Adjust padding to reduce space
# # # # # #                 borders: [:bottom],
# # # # # #                 border_color: 'c9ced5'
# # # # # #             }
# # # # # #         }

# # # # # #         @pdf.table(header_title_data, header_title_options)
# # # # # #         @pdf.table(header_icon_data, header_icon_options)
# # # # # #   end

# # # # # #     def mid_section
# # # # # #         mid_section_data = [['General', '', ''],
# # # # # #         ['Category:', 'Product:', 'Ordered by:'],
# # # # # #         [@order.product&.category&.c_name || 'N/A',
# # # # # #          @order.product&.name || 'N/A',
# # # # # #          @order.user&.email]]

# # # # # #          mid_section_options = {
# # # # # #             width: @document_width,
# # # # # #             row_colors: ['ffffff'],
# # # # # #             cell_style: {
# # # # # #                 border_width: 0,
# # # # # #                 borders: [:bottom],
# # # # # #                 border_color: 'c9ced5',
# # # # # #                 padding: [10, 15]
# # # # # #             }
# # # # # #         }

# # # # # #         @pdf.table(mid_section_data, mid_section_options) do |table|
# # # # # #             table.row(0).border_width = 0.5
# # # # # #             table.row(1).text_color = '888892'
# # # # # #             table.row(0).padding = [10, 15]
# # # # # #             table.row(2).size = 11
# # # # # #         end
# # # # # #     end

# # # # # #     def result_section
# # # # # #         report_data = [['Report', '', ''],
# # # # # #             ['Product SKU', 'Size', 'Price']]

# # # # # #         # Since an Order has one Product
# # # # # #         product = @order.product
# # # # # #         report_data << [product.sku, product.size, product.price]

# # # # # #         report_data_options = {
# # # # # #             width: @document_width,
# # # # # #             row_colors: ['ffffff'],
# # # # # #             cell_style: {
# # # # # #                 border_width: 1,
# # # # # #                 borders: [:bottom],
# # # # # #                 border_color: 'c9ced5'
# # # # # #             }
# # # # # #         }

# # # # # #         @pdf.table(report_data, report_data_options) do |table|
# # # # # #             table.row(0).border_width = 0.5
# # # # # #             table.row(0).column(2).text_color = '2787c4'
# # # # # #             table.row(0).column(2).size = 11
# # # # # #             table.row(1).background_color = 'EDEFF5'
# # # # # #             table.row(1..-1).column(1..2).align = :center
# # # # # #             table.row(1).text_color = '465579'
# # # # # #             table.row(1).size = 10
# # # # # #             table.row(1..-1).padding = [10, 15]
# # # # # #             table.row(0).padding = [7, 15]
# # # # # #         end
# # # # # #     end
# # # # # #     def generate_pdf
# # # # # #         header
# # # # # #         mid_section
# # # # # #         result_section
# # # # # #         @pdf.render
# # # # # #     end
# # # # # # end

# # # # #       # <%#= link_to 'Show', order_path(order), class: 'btn btn-sm btn-primary' %>
# # # # #       #         <%# Uncomment the following lines if you want to add these actions %>
# # # # #       #         <%#= link_to 'Edit', edit_order_path(order), class: 'btn btn-sm btn-warning mx-2' %>
# # # # #       #

# # # # # if @order.save
# # # # #       @order.products << Product.where(id: params[:order][:product_ids])  # Associate selected products
# # # # #       redirect_to orders_path, notice: 'Order was successfully created.'
# # # # #     else
# # # # #       @products = Product.all  # Re-fetch products in case of failure
# # # # #       render :new
# # # # #     end
# # # # #   end

# # # # # <p><strong>Total Amount:</strong> <%= number_to_currency(@order.total_amount, unit: "₹") %></p>

# # # # # <%# <!-- app/views/orders/show.html.erb -->
# # # # # <p>
# # # # #   <strong>Order No:</strong>
# # # # #   <%= @order.order_no %>
# # # # # <%# </p>

# # # # # <p>
# # # # #   <strong>Total Amount:</strong>
# # # # #   <%= @order.total_amount %>
# # # # # <%# </p> %> %>
# # # # # <%#
# # # # # <p>
# # # # #   <strong>Products:</strong>
# # # # #   <ul> %>
# # # # #     <#% @order.products.each do |product| %>
# # # # #       <%# <li><%#= product.sku %> - <%#= product.name %></#li> %>
# # # # #     <%# <% end %> %>
# # # # #  <%#  </ul>
# # # # # </p> %>
# # # # #  %>

# # # # <div class="home-container">
# # # #   <div class="overlay-background"></div> <!-- Overlay div -->

# # # #   <div class="container text-center my-5 content-container">
# # # #     <!-- App Logo and Name -->
# # # #     <div class="mb-4">
# # # #       <%= image_tag('app_icon.png', alt: 'App Logo', class: 'app-logo mb-2') %>
# # # #       <h1 class="app-name">CRM App</h1>
# # # #     </div>

# # # #     <!-- Large Heading -->
# # # #     <div class="heading mb-5">
# # # #       <h2 class="display-4">Discover <span class="text-primary">CRM Portal</span> websites</h2>
# # # #       <h3 class="font-weight-light">built by Shadbox Community</h3>
# # # #     </div>

# # # #     <!-- Sign-In Buttons (only if user is not signed in) -->
# # # #     <% unless user_signed_in? %>
# # # #       <div class="signin-buttons">
# # # #         <%= link_to 'Sign In', new_user_session_path, class: 'btn btn-primary btn-lg mb-3' %>
# # # #         <div class="social-signin">
# # # #           <button class="btn btn-outline-danger mb-0">Sign In with Google</button>
# # # #           <button class="btn btn-outline-primary">Sign In with Facebook</button>
# # # #         </div>
# # # #       </div>
# # # #     <% end %>
# # # #   </div>
# # # # </div>

# # # # <style>
# # # #   .home-container {
# # # #   position: relative;
# # # #   width: 100%;
# # # #   height: 100vh; /* Full-screen height */
# # # #   background-image: url('/assets/home_image.png');
# # # #   background-position: center;
# # # #   background-size: cover;
# # # #   background-repeat: no-repeat;
# # # #   display: flex;
# # # #   align-items: center;
# # # #   justify-content: center;
# # # # }

# # # # .overlay-background {
# # # #   position: absolute;
# # # #   top: 0;
# # # #   left: 0;
# # # #   width: 100%;
# # # #   height: 100%;
# # # #   background-color: rgba(0, 0, 0, 0.6); /* Black with 60% opacity */
# # # #   z-index: -1; /* Ensure the overlay is behind the content */
# # # # }

# # # # .content-container {
# # # #   z-index: 1; /* Ensure the content is above the overlay */
# # # #   color: white; /* Text color to contrast with background */
# # # # }

# # # # .app-logo {
# # # #   width: 100px; /* Adjust logo size */
# # # # }

# # # # h2, h3 {
# # # #   text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5); /* Add shadow for better readability */
# # # # }

# # # # </style>

# # # # <%# if user_signed_in?     %>
# # # # <%#= button_to "Sign Out", destroy_user_session_path, method: :delete, class: 'btn btn-secondary' %>
# # # # <%# else %>
# # # # <%#= link_to "Sign In", new_user_session_path, class: 'btn btn-primary' %>
# # # # <%# end %>
# # # # <%#= link_to 'Categories', categories_path, class: 'btn btn-primary mb-3' %>

# # # # <%# if user_signed_in? %>
# # # #   <%#= button_to "Sign Out", destroy_user_session_path, :method => :delete	 %>
# # # # <%# else %>
# # # #   <%#= link_to "Sign In", new_user_session_path %>
# # # # <%# end %>

# # #  # <%# <span class="notice"><%#= notice %></span>
# # #  # <%# <span class="alert"><%#= alert %></span>

# # #  <nav class="navbar navbar-expand-lg navbar-transparent bg-transparent">
# # #     <div class="container">
# # #       <!-- Application Icon and Name -->
# # #       <a class="navbar-brand" href="#">
# # #         <img src="<%= asset_path('app_icon.png') %>" width="30" height="30" alt="CRM App Icon">
# # #         CRM App
# # #       </a>

# # #       <!-- Toggle button for smaller screens -->
# # #       <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
# # #         <span class="navbar-toggler-icon"></span>
# # #       </button>

# # #       <!-- Navbar Links -->
# # #       <div class="collapse navbar-collapse" id="navbarContent">
# # #         <ul class="navbar-nav mr-auto">
# # #           <li class="nav-item">
# # #             <%= link_to 'Home', root_path, class: 'nav-link' %>
# # #           </li>
# # #           <%# <li class="nav-item"> %>
# # #             <%#= link_to 'About', "#", class: 'nav-link' %>
# # #             <%# </li> %>

# # #             <% if user_signed_in? %>
# # #             <li class="nav-item">
# # #               <%= link_to 'All Products', all_products_path, class: 'nav-link' %>
# # #             </li>
# # #             <li class="nav-item">
# # #               <%= link_to 'Categories', categories_path, class: 'nav-link' %>
# # #             </li>
# # #             <li class="nav-item">
# # #               <%= link_to 'Orders', orders_path, class: 'nav-link' %>
# # #               <%# (current_user) %>
# # #             </li>
# # #             <li class="nav-item">
# # #               <% if user_signed_in? && current_user.role == 'admin' %>
# # #               <%= link_to 'Customer', customers_path, class: 'nav-link' %>
# # #               <% end %>
# # #             </li>
# # #             <% end %>
# # #           </ul>

# # #           <!-- Right Side (Login/Profile) -->
# # #           <ul class="navbar-nav ml-auto">
# # #             <% if user_signed_in? %>
# # #             <li class="nav-item dropdown">
# # #               <a class="nav-link dropdown-toggle" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
# # #                 <i class="fas fa-user"></i> Profile
# # #               </a>
# # #               <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
# # #                 <%= link_to 'My Profile', edit_user_registration_path, class: 'dropdown-item' %>
# # #                 <%= button_to 'Log_out', destroy_user_session_path, method: :delete, class: 'dropdown-item' %>
# # #               </div>
# # #             </li>
# # #             <% else %>
# # #             <li class="nav-item">
# # #               <%= link_to 'Log_in', new_user_session_path, class: 'nav-link' %>
# # #             </li>
# # #             <% end %>
# # #           </ul>
# # #         </div>
# # #       </div>
# # #     </nav>

# # # <div class="home-container">
# # #   <div class="overlay-background" style="opacity: 0.6;"></div>
# # #   <div id="jarallax-container-0">
# # #     <div class="container text-center my-5 content-container">
# # #       <!-- Large Heading -->
# # #       <div class="heading mb-4" >
# # #         <h1 class="display-4 main-heading"><span class="highlight">Your customers will love you <br> one minute from now.</span></h1>
# # #         <p class="subheading">See how your users experience your website in realtime or view <br> trends to see any changes in performance over time.</p>
# # #       </div>

# # #       <!-- Action Buttons -->
# # #       <div class="action-buttons">
# # #          <%= link_to 'Log_in', new_user_session_path, class: 'btn btn-primary btn-lg mx-3' %>
# # #       </div>
# # #     </div>
# # #   </div>
# # # </div>

# # .home-container {
# #   background-position: 50% 50%;
# #   background-size: cover;
# #   background-repeat: no-repeat;
# #   background-image: url('/assets/home_image.jpg');
# #   position: absolute;
# #   left: 0px;
# #   width: 1284px;
# #   height: 600px;
# #   overflow: hidden;
# #   transform-style: preserve-3d;
# #   backface-visibility: hidden;
# #   will-change: transform, opacity;
# #   margin-top: 0px;
# #   transform: translate3d(0px, 0px, 0px);
# # }

# # .overlay-background {
# #   position: absolute;
# #   top: 0;
# #   left: 0;
# #   width: 100%;
# #   height: 100%;
# #   background: #333333; /* Dark overlay */
# #   z-index: -1; /* Ensure the overlay is behind the content */
# # }

# # .content-container {
# #   z-index: 1; /* Ensure the content is above the overlay */
# #   color: white; /* Text color to contrast with background */
# #   max-width: 900px; /* Restrict content width */
# # }

# # .main-heading {
# #   font-size: 3rem; /* Larger heading size */
# #   font-weight: 700;
# #   line-height: 1.2;
# # }

# # .highlight {
# #   color: white; /* Keep highlight text white */
# # }

# # .subheading {
# #   font-size: 1.2rem; /* Smaller font size for subheading */
# #   color: rgba(255, 255, 255, 0.8); /* Slightly lighter for better contrast */
# #   margin-bottom: 3rem;
# # }

# # .action-buttons .btn-primary {
# #   background-color: #4c57ed;
# #   border-color: #4c57ed;
# #   padding: 1rem 2.5rem;
# #   font-size: 1.1rem;
# # }

# # .action-buttons .btn-outline-light {
# #   padding: 1rem 2.5rem;
# #   font-size: 1.1rem;
# # }

# # h1, p {
# #   text-shadow: 1px 1px 10px rgba(0, 0, 0, 0.5); /* Add subtle shadow for readability */
# # }

# # .home-container {
# #   background-position: center center;
# #   background-size: cover;
# #   background-repeat: no-repeat;
# #   background-image: url('/assets/home_image.jpg');
# #   position: relative;
# #   width: 100%;
# #   height: 100vh; /* Full-screen height */
# #   overflow: hidden;
# # }

# # .overlay-background {
# #   position: absolute;
# #   top: 0;
# #   left: 0;
# #   width: 100%;
# #   height: 100%;
# #   background: rgba(0, 0, 0, 0.6); /* Dark overlay */
# #   z-index: -1; /* Ensure the overlay is behind the content */
# # }

# # .content-container {
# #   z-index: 1; /* Ensure the content is above the overlay */
# #   color: white; /* Text color to contrast with background */
# #   max-width: 900px; /* Restrict content width */
# #   text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.5); /* Shadow for readability */
# # }

# # .main-heading {
# #   font-size: 3rem;
# #   font-weight: 700;
# #   line-height: 1.2;
# # }

# # .subheading {
# #   font-size: 1.2rem;
# #   color: rgba(255, 255, 255, 0.8); /* Slightly lighter for better contrast */
# #   margin-bottom: 3rem;
# # }

# # .action-buttons .btn-primary {
# #   background-color: #4c57ed;
# #   border-color: #4c57ed;
# #   padding: 1rem 2.5rem;
# #   font-size: 1.1rem;
# # }

# <head>
#   <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
#   <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
#   <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

# </head>

# <body>
#   <div class="container mt-4">
#     <h1 class="mb-4"><%= @product.name %></h1>

#     <div class="row">
#       <div class="col-md-8">
#         <h4>Details</h4>
#         <div id="productCarousel" class="carousel slide" data-ride="carousel">
#           <div class="carousel-inner">
#             <% if @product.images.attached? %>
#               <% @product.images.each_with_index do |image, index| %>
#                 <div class="carousel-item <%= 'active' if index == 0 %>">
#                   <%= image_tag(image, class: "img-fluid") %>
#                 </div>
#               <% end %>
#             <% end %>
#           </div>

#           <!-- Controls -->
#           <a class="carousel-control-prev" href="#productCarousel" role="button" data-slide="prev">
#             <span class="carousel-control-prev-icon" aria-hidden="true"></span>
#             <span class="sr-only">Previous</span>
#           </a>
#           <a class="carousel-control-next" href="#productCarousel" role="button" data-slide="next">
#             <span class="carousel-control-next-icon" aria-hidden="true"></span>
#             <span class="sr-only">Next</span>
#           </a>
#         </div>

#         <div class="product-card mt-4">
#           <div class="product-header">
#             <h2 class="product-title"><%= @product.name %></h2>
#           </div>
#           <div class="product-details">
#             <p><strong>ID:</strong> <%= @product.id %></p>
#             <p><strong>SKU:</strong> <%= @product.sku %></p>
#             <p><strong>Size:</strong> <%= @product.size %></p>
#             <p><strong>Price:</strong> $<%= @product.price %></p>
#             <p><strong>MRP:</strong> $<%= @product.mrp %></p>
#             <p><strong>Selling Price:</strong> $<%= @product.selling_price %></p>
#           </div>
#         </div>

#         <div class="product-actions mt-3">
#           <%= link_to 'Edit', edit_category_product_path(@category, @product), class: 'btn btn-warning mb-0' %>
#           <%= link_to 'Back to Products', category_products_path(@category), class: 'btn btn-secondary' %>
#         </div>
#       </div>
#     </div>
#   </div>
# </body>

# <style>
#   /* Typography and Color Enhancements */
#   body {
#     font-family: 'Helvetica Neue', Arial, sans-serif;
#     background-color: #f4f6f9;
#     color: #333;
#     line-height: 1.6;
#   }

#   h1, h4 {
#     font-weight: bold;
#     color: #343a40;
#   }

#   h1 {
#     font-size: 2.5rem;
#   }

#   h4 {
#     font-size: 1.25rem;
#     margin-bottom: 1rem;
#   }

#   .container {
# <%#     background-color: #fff; %>
#     border-radius: 15px;
#     padding: 10px;
#     box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
#   }

#   .carousel-item img {
#     max-width: 500px;
#     max-height: 500px;
#     margin: 0 auto;
#     border-radius: 10px;
#     box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
#   }

#   .carousel-control-prev-icon,
#   .carousel-control-next-icon {
#     background-color: rgba(0, 0, 0, 0.5);
#     border-radius: 50%;
#   }

#   /* Position the navigation buttons closer to the center of the carousel */
#   .carousel-control-prev {
#     left: -20px;
#   }

#   .carousel-control-next {
#     right: -50px;
#   }

#   @media (min-width: 768px) {
#     .carousel-control-prev {
#       left: -65px;
#     }

#     .carousel-control-next {
#       right: -50px;
#     }
#   }

#   /* Product Card Styling */
#   .product-card {
#     background-color: #fff;
#     border-radius: 10px;
#     box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
#     padding: 20px;
#     margin-bottom: 30px;
#     transition: transform 0.3s ease, box-shadow 0.3s ease;
#   }

#   .product-card:hover {
#     transform: translateY(-5px);
#     box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
#   }

#   .product-header {
#     text-align: center;
#     margin-bottom: 20px;
#   }

#   .product-title {
#     font-size: 1.8rem;
#     font-weight: bold;
#     color: #343a40;
#   }

#   .product-details p {
#     font-size: 1rem;
#     margin-bottom: 10px;
#     color: #666;
#   }

#   .product-details p strong {
#     color: #343a40;
#   }

#   /* Button Styling */
#   .btn-primary {
#     background-color: #007bff;
#     border-color: #007bff;
#     transition: background-color 0.3s ease, border-color 0.3s ease;
#   }

#   .btn-primary:hover {
#     background-color: #0056b3;
#     border-color: #0056b3;
#   }

#   .btn-warning {
#     background-color: #ffc107;
#     border-color: #ffc107;
#     color: #fff;
#   }

#   .btn-warning:hover {
#     background-color: #e0a800;
#     border-color: #d39e00;
#   }

#   .btn-secondary {
#     background-color: #6c757d;
#     border-color: #6c757d;
#   }

#   .btn-secondary:hover {
#     background-color: #5a6268;
#     border-color: #545b62;
#   }
# </style>

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
    header_column_widths = [@document_width * 2 / 3, @document_width * 1 / 3]

    # Order Summary Title
    header_title_data = [['Order Summary']]
    header_title_options = {
      column_widths: [@document_width],
      row_colors: ['EDEFF5'],
      cell_style: {
        border_width: 0,
        padding: [8, 6, 0, 10],
        size: 16,
        font: 'montserrat'
      }
    }

    # Customer Details
    customer_details = [
      ['Customer Email:', @order.user.email],
      ['Total Products:', @order.products.count.to_s]
    ]

    customer_details_options = {
      column_widths: header_column_widths,
      row_colors: ['426EF5'],
      cell_style: {
        border_width: 0,
        padding: [5, 5],
        size: 10,
        font: 'montserrat'
      }
    }

    # Header Icon (Logo)
    header_icon_data = [
      [{ image: ICON_IMG_PATH, position: :right, scale: 0.1, colspan: 2 }].flatten
    ]

    header_icon_options = {
      column_widths: header_column_widths,
      row_colors: ['D1D3D9'],
      cell_style: {
        border_width: 1,
        padding: [4, 4],
        borders: [:bottom],
        border_color: 'c9ced5'
      }
    }

    # Render Header
    @pdf.table(header_icon_data, header_icon_options)
    @pdf.table(header_title_data, header_title_options)
    @pdf.table(customer_details, customer_details_options) # Adding customer details
  end

  def mid_section
    # Initialize the mid_section data with a header row
    mid_section_data = [['General', '', ''], ['Category', 'Product', 'Ordered by (Admin)']]

    # For each product, add a new row with its category and name
    @order.products.each do |product|
      # Find the admin who placed the order (assuming admin creates the order)
      admin_user = User.find_by(role: 'admin') # Or however you track the admin

      mid_section_data << [
        product.category&.c_name || 'N/A',
        product.name || 'N/A',
        admin_user&.email || 'N/A' # Display admin's email here
      ]
    end

    # Mid-section table options for styling
    mid_section_options = {
      width: @document_width,
      row_colors: ['ffffff'],
      cell_style: {
        border_width: 1,
        borders: [:bottom],
        border_color: 'c9ced5',
        padding: [10, 15]
      }
    }

    # Render the table
    @pdf.table(mid_section_data, mid_section_options) do |table|
      table.row(0).border_width = 0.5
      table.row(0).column(2).text_color = '2787c4'
      table.row(0).column(2).size = 11
      table.row(1).background_color = 'EDEFF5'
      table.row(1..-1).column(1..2).align = :center
      table.row(1).text_color = '465579'
      table.row(1).size = 10
      table.row(1..-1).padding = [10, 15]
      table.row(0).padding = [7, 15]
    end
  end

  def result_section
    report_data = [['Report', '', ''], ['Product SKU', 'Size', 'Price']]
    @order.products.each do |product|
      report_data << [product.sku, product.size, format_currency(product.price)]
    end

    report_data << ['Total Amount:', '', format_currency(@order.total_amount)]

    report_data_options = {
      width: @document_width,
      row_colors: ['ffffff'],
      cell_style: {
        border_width: 1,
        borders: [:bottom],
        border_color: 'c9ced5'
      }
    }

    @pdf.table(report_data, report_data_options) do |table|
      table.row(0).border_width = 0.5
      table.row(0).column(2).text_color = '2787c4'
      table.row(0).column(2).size = 11
      table.row(1).background_color = 'EDEFF5'
      table.row(1..-1).column(1..2).align = :center
      table.row(1).text_color = '465579'
      table.row(1).size = 10
      table.row(1..-1).padding = [10, 15]
      table.row(0).padding = [7, 15]
    end
  end

  def generate_pdf
    header
    mid_section
    result_section
    @pdf.render
  end

  def format_currency(amount)
    format('₹%.2f', amount)
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
  product_table_options = {
    width: @document_width,
    row_colors: %w[000000 ffffff],
    cell_style: {
      border_width: 1,
      borders: [:bottom],
      border_color: 'c9ced5',
      padding: [8, 8],
      size: 10,
      font: 'montserrat'
    }
  }

  # Render Product Table
  @pdf.table(product_table_data, product_table_options) do |table|
    table.row(0).font_style = :bold
    table.row(0).text_color = 'c9ced5'
    table.row(0).size = 12
    table.row(1..-1).column(1..-1).align = :center
    table.row(1..-1).size = 10
    table.row(1..-1).text_color = '000000'
  end

  @pdf.move_down 20
end
