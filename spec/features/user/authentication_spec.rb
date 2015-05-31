require 'spec_helper'

feature 'Authentication', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    visit '/#/sign_in'
    @login_page = LoginPage.new
    @login_page.sign_in(@user.email, @user.password)
  end

  feature 'login' do
    scenario 'with valid inputs' do
      expect(page).to have_content('Sign out')
    end

    scenario 'redirect after login' do
      expect(page).to have_content('Welcome')
    end
  end

  feature 'page access' do
    scenario 'visiting groups page when signed in' do
      @login_page.sign_in(@user.email, @user.password)

      # We want Capybara to wait for sign-in to finish happening
      # before we visit /groups.
      expect(page).to have_css('h1', text: 'Home')

      visit '/groups'
      expect(page).to have_css('h1', text: 'Groups')
    end

    scenario 'visiting "groups" page when not signed in' do
      visit '/groups'
      expect(page).not_to have_css('h1', text: 'Groups')
    end
  end
  
end