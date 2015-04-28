require 'rails_helper'

RSpec.feature "AdminDashboard", type: :feature do
  describe("an admin can see the dashboard with companies") do
    let(:admin) do
      User.create(email: 'admin@example.com',
                  password: 'password',
                  role: 1)
    end

    def login
      visit admin_login_path

      within('.login') do
        fill_in 'session[email]', with: admin.email
        fill_in 'session[password]', with: admin.password
      end
      click_link_or_button('Login')
    end

   it "views uncontacted companies on dashboard" do
      companies = create_list(:company, 10, status: "uncontacted")
      login

      expect(current_path).to eq(admin_dashboard_index_path)
      within(".uncontacted-companies") do
        expect(page).to have_link(companies.first.organization)
        expect(page).to have_link(companies.last.organization)
        expect(companies.first.updated_at <= companies.last.updated_at).to eq(true)
      end
    end

    it "views contacted companies on dashboard" do
      companies = create_list(:company, 10, status: "contacted")
      login

      expect(current_path).to eq(admin_dashboard_index_path)

      within(".contacted-companies") do
        expect(page).to have_link(companies.first.organization)
        expect(page).to have_link(companies.last.organization)
        expect(companies.first.updated_at <= companies.last.updated_at).to eq(true)
      end
    end

    it "views confirmed companies on dashboard" do
      companies = create_list(:company, 10, status: "confirmed")
      login

      expect(current_path).to eq(admin_dashboard_index_path)

      within(".confirmed-companies") do
        expect(page).to have_link(companies.first.organization)
        expect(page).to have_link(companies.last.organization)
        expect(companies.first.updated_at <= companies.last.updated_at).to eq(true)
      end
    end

    it "views dead companies on dashboard" do
      companies = create_list(:company, 10, status: "dead")
      login

      expect(current_path).to eq(admin_dashboard_index_path)

      within(".dead-companies") do
        expect(page).to have_link(companies.first.organization)
        expect(page).to have_link(companies.last.organization)
        expect(companies.first.updated_at <= companies.last.updated_at).to eq(true)
      end
    end

    it "can click to view details of a company" do
      companies = create_list(:company, 10, status: "uncontacted")
      login

      within(".uncontacted-companies") do
        click_link(companies.last.organization, match: :first)
      end
      expect(current_path).to eq(admin_company_path(companies.last.id))
    end
  end
end