class CompaniesController < ApplicationController
  before_action :set_company, except: [:index, :create, :new]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def show
  end

  def create
    @company = Company.new(company_params)
    add_city_and_state(@company, company_params) if are_basic_conditions_true?(company_params)
    if @company.save
      redirect_to companies_path, notice: "Saved"
    else
      validationErrorsHandling(:new, @company.errors)
    end
  end

  def edit
  end

  def update
    add_city_and_state(@company, company_params) if zip_code_changed?(@company, company_params)
    if @company.update(company_params)
      redirect_to companies_path, notice: "Changes Saved"
    else
      validationErrorsHandling(:edit, @company.errors)
    end
  end

  def destroy
    if @company.destroy
      redirect_to companies_path, notice: "Company deleted successfully"
    else
      errors = {}
      errors[:destroy_] = "Unable to delete the company"
      validationErrorsHandling(:show, errors)
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :legal_name,
      :description,
      :zip_code,
      :phone,
      :email,
      :owner_id,
    )
  end

  def set_company
    @company = Company.find(params[:id])
  end

  def are_basic_conditions_true?(company_params)
    company_params.present? && company_params.has_key?(:zip_code) && company_params[:zip_code].present?
  end

  def zip_code_changed?(company, company_params)
    are_basic_conditions_true?(company_params) && (company.zip_code.to_s != company_params[:zip_code].to_s)
  end

  def add_city_and_state(company, company_params)
    get_data_from_zipcode = ZipCodes.identify(company_params[:zip_code])                                                           
    if get_data_from_zipcode.present?
      company.city = get_data_from_zipcode[:city]
      company.state = get_data_from_zipcode[:state_name]
    else    # case when you update from valid zip code to invalid.
      company.city = nil  
      company.state = nil
    end
  end

  def validationErrorsHandling(render_action, validation_errors)
    if validation_errors.has_key?(:email)
      flash.now[:error] = validation_errors[:email][0].to_s
      render render_action
      return
    end

    if validation_errors.has_key?(:destroy_)
      flash.now[:error] = validation_errors[:destroy_].to_s
      render render_action
      return
    end
    # handle other validation errors here
  end
  
end
