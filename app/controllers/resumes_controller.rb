class ResumesController < ApplicationController

  def generate_pdf
    @full_data = params[:sections]
    @rand = (0...6).map { ('a'..'z').to_a[rand(26)] }.join

    html = render_to_string(:action => :generate_pdf)
    pdf = WickedPdf.new.pdf_from_string(html)

    save_path = Rails.root.join('public/pdfs',@rand+'.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end

    @resume = Resume.create(name: @rand)

    if params[:current_user]
      @user = User.find(params[:current_user])
      @user.resumes << @resume
    end

    if !!request.xhr?
      render :text => request.host_with_port+"/"+@rand+'.pdf'
    else
      respond_to do |format|
        format.html
        format.pdf do
          redirect_to "/#{@rand}.pdf".to_s
          #render :action => @rand+".pdf"
          #send_data(pdf,
          #          :filename => @rand+".pdf",
          #          :disposition => 'attachment')
        end
      end
    end
  end

  def form
    @resumes = current_user.resumes if current_user
  end

  def resumes_by_me
    @resumes = current_user.resumes
  end

  def create_json
    @myhash = {}
    @resume = Resume.find_by_name(params[:name])
  end
end