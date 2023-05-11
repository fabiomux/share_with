# frozen_string_literal: true

TWITTER_BUTTON = '<a href="https://twitter.com/share" class="twitter-share-button"
 data-size="large" data-show-count="false">Tweet</a>'

TWITTER_ICON = '<a href="https://twitter.com/share?text=&url=https%3A%2F%2Ffreeaptitude
.altervista.org%2Fprojects%2Fshare-with.html&related=&hashtags=" title="Share with Twitter" class=
"share-with-twitter"><img src="https://cdnjs.cloudflare.com/ajax/libs/simple-icons/8.6.0/twitter.svg"
 alt="Share with Twitter" width="48" height="48" /></a>'

TWITTER_ICON_AND_TEXT = '<a href="https://twitter.com/share?text=&url=https%3A%2F%2Ffreeaptitude
.altervista.org%2Fprojects%2Fshare-with.html&related=&hashtags=" title="Share with Twitter" class=
"share-with-twitter"><img src="https://cdnjs.cloudflare.com/ajax/libs/simple-icons/8.6.0/twitter.svg"
 alt="Share with Twitter" width="48" height="48" /> Twitter</a>'

TWITTER_ICON_WITH_TAGS = '<a href="https://twitter.com/share?text=&url=https%3A%2F%2Ffreeaptitude
.altervista.org%2Fprojects%2Fshare-with.html&related=&hashtags=ruby,flutter" title="Share with Twitter"
 class="share-with-twitter"><img src="https://cdnjs.cloudflare.com/ajax/libs/simple-icons/8.6.0/twitter.svg"
 alt="Share with Twitter" width="48" height="48" /></a>'

RSpec.describe ShareWith::Service do
  before(:all) do
    @service = ShareWith::Service.new("twitter")
    @service.set_value("url", "https://freeaptitude.altervista.org/projects/share-with.html")
  end

  describe "Twitter" do
    context "templates" do
      it "renders a button template" do
        str = @service.render("button")
        expect(str).to eq(TWITTER_BUTTON.gsub(/\n/, ""))
      end

      it "renders an icon template" do
        str = @service.render("icon")
        expect(str).to eq(TWITTER_ICON.gsub(/\n/, ""))
      end

      it "renders an icon and text template" do
        str = @service.render("icon_and_text")
        expect(str).to eq(TWITTER_ICON_AND_TEXT.gsub(/\n/, ""))
      end
    end

    context "params" do
      it "adds a conditional param" do
        @service.set_conditional_param("twitter:hashtags", "ruby,flutter")
        str = @service.render("icon")
        expect(str).to eq(TWITTER_ICON_WITH_TAGS.gsub(/\n/, ""))
      end
    end
  end
end
