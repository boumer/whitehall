class Admin::PersonTranslationsController < Admin::BaseController
  before_filter :load_translated_and_english_people, except: [:index]
  helper_method :translation_locale

  def index
    @translated_locales = (person.translated_locales - [:en]).map {|l| Locale.new(l)}
    @missing_locales = Locale.non_english - @translated_locales
  end

  def create
    redirect_to edit_admin_person_translation_path(person, id: translation_locale)
  end

  def edit
  end

  def update
    if @translated_person.update_attributes(params[:person])
      redirect_to admin_person_translations_path(@translated_person)
    else
      render action: 'edit'
    end
  end

  private

  def load_translated_and_english_people
    @translated_person = LocalisedModel.new(person, translation_locale.code)
    @english_person = LocalisedModel.new(person, :en)
  end

  def translation_locale
    @translation_locale ||= Locale.new(params[:translation_locale] || params[:id])
  end

  def person
    @person ||= Person.find(params[:person_id])
  end
end
