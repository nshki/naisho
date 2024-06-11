module Company::EmailCorrectable
  extend ActiveSupport::Concern

  # List of emails that have been verified by website. If a website here does not match
  # domains with the associated email address, it is because the domain resolved to a
  # different one.
  VERIFIED_EMAILS_BY_WEBSITE = {
    # Bounce list. The previous email for each of these sites from sources were invalid,
    # so we're using the emails listed on each site's privacy policy.
    "0ptimus.com" => "privacy@0ptimus.com", # https://0ptimus.com/privacy-policy/
    "180bytwo.com" => "privacy@anteriad.com", # https://anteriad.com/privacy-policy
    "adttribution.com" => "info@adttribution.com", # https://adttribution.com/privacy-policy.html
    "alc.com" => "privacy.officer@adstradata.com", # https://adstradata.com/privacy-policy/
    "altisource.com" => "privacy@altisource.com", # https://www.altisource.com/Privacy-Policy/
    "biscred.com" => "privacy@biscred.com", # https://www.biscred.com/privacy-policy
    "carevoyance.com" => "privacy@definitivehc.com", # https://www.definitivehc.com/privacy-center/notices
    "catalina.com" => "dpo@catalina.com", # https://www.catalina.com/legal
    "cbcinnovis.com" => "clientsuccess@factualdata.com", # https://www.factualdata.com/privacy/privacy-policy
    "compactlists.com" => "privacy.compliance@deepsync.com", # https://deepsync.com/privacy-policy/
    "dataverify.com" => "info@dataverify.com", # https://info.dataverify.com/privacy
    "digicenter.com" => "privacy@collectivedata.io", # https://www.collectivedata.io/website-visitor-privacy-policy/
    "dotin.us" => "legal-notices@opensesame.com", # https://www.opensesame.com/privacy
    "easybackgrounds.com" => "privacy@disa.com", # https://ghrr.com/privacy-policy
    "enginemediaexchange.com" => "support@platform.cadent.tv", # https://cadent.tv/website-privacy-policy/
    "entelo.com" => "privacy@silkroad.com", # https://www.entelo.com/legal/privacy
    "infortal.com" => "support@infortal.com", # https://infortal.com/privacy-policy/
    "kbmg.com" => "dpo@vml.com", # https://www.vml.com/privacy-policy
    "killi.io" => "privacy@reklaimyours.com", # https://www.reklaimyours.com/privacy-policy
    "localpages.com" => "support@localpages.com", # https://localpages.com/privacy
    "lscmarketinggroup.com" => "privacy@listservices.com", # https://lscmarketinggroup.com/privacy-policy/
    "monocl.com" => "privacy@definitivehc.com", # https://www.definitivehc.com/privacy-center/notices
    "nielsen.com" => "privacy.department@nielsen.com", # https://www.nielsen.com/legal/privacy-principles/
    "paramountdirectmarketing.com" => "ccpa@paramountdirectmarketing.com", # https://paramountdirectmarketing.com/privacy-policy.php
    "paramountlists.com" => "ccpa@paramountdirectmarketing.com", # https://paramountdirectmarketing.com/privacy-policy.php
    "possiblenow.com" => "privacy@possiblenow.com", # https://www.possiblenow.com/privacy-statement
    "proximaplatform.com" => "alexyaybar@ohomail.com", # https://www.proximaplatform.com/ccpa
    "quorum.us" => "info@quorum.us", # https://www.quorum.us/privacy-policy/
    "rpmleader.com" => "info@rpmleader.com", # https://rpmleader.com/privacy-policy
    "simiocloud.com" => "privacy@simiocloud.com", # https://simiocloud.com/simiocloud-products-services-privacy-policy/
    "smarteinc.com" => "privacy@smarte.pro", # https://www.smarte.pro/privacy-policy/english
    "sterling.ai" => "privacy@sterling.ai", # https://sterling.ai/privacy-policy/
    "sterlingstrategies.co" => "privacy@sterling.ai", # https://sterling.ai/privacy-policy/
    "superpages.com" => "dpo@thryv.com", # https://www.thryv.com/privacy/
    "valassis.com" => "privacyrequests@vericast.com", # https://www.vericast.com/privacy-policy-2023/
    "yobi.ai" => "info@yobi.ai", # https://yobi.ai/privacy-policy/

    # General list. The previous email for each of these sites pointed toward a specific
    # individual working at these companies, but those aren't reliable especially if
    # there's employee churn. This, again, uses the emails listed on each site's privacy
    # policy.
    "4-eyes.ai" => "privacy@4-eyes.ai", # https://4-eyes.ai
    "accucomcorp.com" => "privacy@infopay.com", # https://www.infopay.com/privacy
    "achcoop.com" => "privacy@achcoop.com", # https://www.achcoop.com/privacy-policy
    "acxiom.com" => "consumeradvo@acxiom.com", # https://www.acxiom.com/privacy/privacy-policy-www-acxiom-com/
    "advantagesolutions.net" => "corp.comm@advantagesolutions.net", # https://advantagesolutions.net/privacy-policy/
    "agrgroupinc.com" => "privacy@agrgroupinc.com", # https://www.agrgroupinc.com/
    "altairdata.com" => "asales@altairdata.com", # https://www.altairdata.com/altair-privacy-policy/
    "anteriad.com" => "privacy@anteriad.com", # https://anteriad.com/privacy-policy
    "applecart.co" => "privacy@applecart.co", # https://www.applecart.co/privacy
    "arrakis.ai" => "privacy@arrakis.ai", # https://www.arrakis.ai/arrakis-privacy-policy
    "astoriacompany.com" => "bizdev@astoriacompany.com", # https://astoriacompany.com/privacy-policy/
    "attomdata.com" => "privacy@attomdata.com", # https://www.attomdata.com/privacy/
    "audigent.com" => "yourprivacyrights@audigent.com", # https://audigent.com/privacypolicy/
    "autoweb.com" => "consumercare@autoweb.com", # https://www.autoweb.com/
    "backgroundchecks.com" => "info@backgroundchecks.com", # https://www.backgroundchecks.com/privacy-policy
    "backgroundsonline.com" => "support@backgroundsonline.com", # https://clients.backgroundsonline.com/policies/privacy
    "bigdbm.com" => "privacy@bigdbm.com", # https://bigdbm.com/privacy-policy/
    "bookyourdata.com" => "data@bookyourdata.com", # https://www.bookyourdata.com/privacy-policy
    "brightcheck.com" => "support@brightcheck.com", # https://brightcheck.com/privacy-policy/
    "catalist.us" => "privacy@catalist.us", # https://catalist.us/privacy-policy/
    "censia.com" => "support@censia.com", # https://www.censia.com/privacy-policy/
    "cicredit.com" => "support@cicredit.com", # https://www.ciccredit.com/information-security-policy-and-guideline/
    "claritas.com" => "privacyinfo@claritas.com", # https://claritas.com/privacy-legal/
    "clickagy.com" => "privacy@clickagy.com", # https://www.clickagy.com/privacy/
    "coleinformation.com" => "yoursuccess@coleinformation.com", # https://coleinformation.com/contact-us/
    "compile.com" => "privacy@compile.com", # https://www.compile.com/privacy/
    "completemailinglists.com" => "privacy-inquiries@completemailinglists.com", # https://completemailinglists.com/privacy-policy
    "completemedicallists.com" => "info@completemedicallists.com", # https://completemedicallists.com/privacy.php
    "connectedinvestors.com" => "dataprivacy@connectedinvestors.com", # https://connectedinvestors.com/content/privacy-policy
    "connextdigital.com" => "privacy@connextdigital.com", # https://connextdigital.com/privacy-policy/
    "contentgine.com" => "privacy@pharosiq.com", # https://legal.pharosiq.com/privacy-policy
    "costar.com" => "costarprivacy1@costar.com", # https://www.costar.com/about/privacy-notice
    "crosspixel.net" => "cpprivacy@crosspixel.net", # https://crosspixel.net/privacy-policy/
    "dataaxlenonprofit.com" => "privacyteam@data-axle.com", # https://www.dataaxlenonprofit.com/privacy-policy/
    "datadelivers.com" => "privacy@datadelivers.com", # https://datadelivers.com/privacy-policy/
    "datadirectmarketing.com" => "info@datadirectmarketing.com", # https://datadirectmarketing.com/
    "datasys.com" => "support@datasys.com", # https://datasys.com/privacy-policy
    "deloitte.com" => "usprivacyquestions@deloitte.com", # https://www2.deloitte.com/us/en/footerlinks1/privacy.html
    "deluxe.com" => "privacy@deluxe.com", # https://www.deluxe.com/policy/privacy/
    "digdevdirect.com" => "support@digdevdirect.com", # https://www.digdevdirect.com/privacy-policy/
    "disqus.com" => "privacy@disqus.com", # https://disqus.com/privacy-policy/
    "emerges.com" => "privacy@emerges.com", # https://www.emerges.com/Privacy-Policy_ep_42-1.html
    "evorra.com" => "hello@evorra.com", # https://evorra.com/privacy-data-policies/privacy-policy/
    "fetcher.ai" => "support@fetcher.ai", # https://fetcher.ai/privacy
    "findem.ai" => "privacy@findem.ai", # https://www.findem.ai/privacy-policy
    "finthrive.com" => "privacy@finthrive.com", # https://finthrive.com/privacy-policy
    "firstorion.com" => "privacy@firstorion.com", # https://firstorion.com/first-orion-global-privacy-and-compliance-dashboard/
    "fourthwall.tv" => "privacypolicy@fourthwall.tv", # https://www.fourthwall.tv/privacy-fourthwall
    "fusedleads.com" => "info@fusedleads.com", # https://www.fusedleads.com/contact-us/
    "fushiamedia.com" => "support@fushiamedia.com", # https://fushiamedia.com/privacy
    "gladiknow.com" => "support@gladiknow.com", # https://gladiknow.com/privacy-policy
    "harmonresearch.com" => "info@harmonresearch.com", # https://www.harmonresearch.com/privacy-policy
    "healthcare.com" => "privacy@healthcare.com", # https://www.healthcare.com/privacy-policy
    "healthwisedata.com" => "info@healthwisedata.com", # https://www.healthwisedata.com/privacy
    "homeownersmarketingservices.com" => "dnm@homeownersmarketingservices.com", # https://homeownersmarketingservices.com/privacy-policy/
    "hunter.io" => "privacy@hunter.io", # https://hunter.io/privacy-policy
    "idengine.com" => "contact@idengine.com", # https://idengine.com/privacy-policy/
    "inmarket.com" => "privacy@inmarket.com", # https://inmarket.com/privacy/
    "intentgine.com" => "privacy@intentgine.com", # https://intentgine.com/privacy-policy/
    "intentiq.com" => "privacy@intentiq.com", # https://www.intentiq.com/technology-privacy-policy/
    "intentmacro.com" => "privacy@intentmacro.com", # https://intentmacro.com/privacy-policy/
    "internetbrands.com" => "privacy@internetbrands.com", # https://www.internetbrands.com/privacy/privacy-main
    "irys.us" => "privacy@irys.us", # https://irys.us/privacy-policy
    "jdmlistservices.com" => "privacy@jdmlistservices.com", # https://jdmlistservices.com/privacy-policy
    "jkidconsulting.com" => "contact@jkidconsulting.com", # https://jkidconsulting.com/
    "kalibrate.com" => "privacy@kalibrate.com", # https://kalibrate.com/privacy-policy/
    "keono.com" => "privacy@keono.com", # https://keono.com/privacy-policy/
    "komodohealth.com" => "info@komodohealth.com", # https://www.komodohealth.com/privacy-notice
    "l2-data.com" => "privacy@l2political.com", # https://l2-data.com/l2-privacy-policy/
    "lciinc.com" => "privacy@g2risksolutions.com", # https://g2risksolutions.com/privacy-notice/
    "lead.co" => "contact@lead.co", # https://lead.co/privacy
    "lead411.com" => "support@lead411.io", # https://www.lead411.com/privacy-policy/
    "lighthouselist.com" => "privacy@lighthouselist.com", # https://www.lighthouselist.com/privacy-policy
    "lionsharemarketing.com" => "webmaster@lionsharemarketing.com", # https://www.lionsharemarketing.com/privacy-policy/
    "listservicedirect.com" => "info@listservicedirect.com", # https://listservicedirect.com/privacy-policy/
    "locatesmarter.com" => "privacy@locatesmarter.com", # https://locatesmarter.com/privacy-policy/
    "lsmapps.com" => "privacy@lsmapps.com", # https://www.lsmapps.com/privacy-policy
    "m1-data.com" => "service@m1-data.com", # https://m1-data.com/privacy-policy/
    "marketforcecorp.com" => "privacy@marketforcecorp.com", # https://marketforcecorp.com/privacy-policy/
    "mchdata.com" => "info@mchdata.com", # https://www.mchdata.com/about/privacy-policy
    "mediasourcesolutions.com" => "sales@mediasourcesolutions.com", # https://www.mediasourcesolutions.com/contact-us/
    "medprosystems.com" => "privacy@medprosystems.com", # https://www.medprosystems.com/privacy-policy/
    "minervadata.xyz" => "privacy@minervadata.xyz", # https://realtors.minervadata.xyz/privacy-policy
    "mobilewalla.com" => "privacy@mobilewalla.com", # https://www.mobilewalla.com/website-privacy
    "modfxlabs.com" => "opt.out@modfxlabs.com", # https://modfxlabs.com/
    "mrginc.com" => "info@mrginc.com", # https://www.mrginc.com/privacy-policy
    "multimedialists.com" => "compliance@multimedialists.com", # https://multimedialists.com/privacy-policy/
    "myfico.com" => "privacyteam@fico.com", # https://www.myfico.com/policy/privacy-policy
    "newfrontierdata.com" => "help@newfrontierdata.com", # https://newfrontierdata.com/privacy-policy/
    "nextwavemarketingstrategies.com" => "compliance@agedleadstore.com", # https://agedleadstore.com/privacy-policy/
    "owneriq.com" => "privacy@owneriq.com", # https://www.owneriq.com/privacy-notice
    "pacificeast.com" => "privacy@pacificeast.com", # https://www.pacificeast.com/privacy-policy/
    "partnerscredit.com" => "techsupport@partnerscredit.com", # https://partnerscredit.com/privacy-policy.html
    "popacta.com" => "contact@popacta.com", # https://popacta.com/privacy-policy/
    "porchgroupmedia.com" => "privacy@porchgroupmedia.com", # https://porchgroupmedia.com/privacy-policy/
    "quantcast.com" => "privacy@quantcast.com", # https://legal.quantcast.com/#products-and-services-privacy-policy
    "quinstreet.com" => "legalq@quinstreet.com", # https://www.quinstreet.com/privacy-notice/
    "radaris.com" => "customer-service@radaris.com", # https://radaris.com/page/privacy
    "realeflow.com" => "privacy@realeflow.com", # https://cdn.realeflow.com/privacy-policy.pdf
    "realsourcedata.com" => "privacy@realsourcedata.com", # https://www.realsourcedata.com/privacy-policy
    "refinition.com" => "optout@refinition.com", # https://refinition.com/privacy-policy/
    "resonate.com" => "privacy@resonate.com", # https://www.resonate.com/privacy-policy/
    "revealmobile.com" => "privacy@revealmobile.com", # https://revealmobile.com/privacy/
    "sheerid.com" => "privacy@sheerid.com", # https://www.sheerid.com/global-privacy-policy/
    "siteimpact.com" => "dataprivacy@siteimpact.com", # https://siteimpact.com/privacypolicy.php
    "slashdotmedia.com" => "privacy@slashdotmedia.com", # https://slashdotmedia.com/privacy-statement/
    "slintel.com" => "privacy@6sense.com", # https://6sense.com/privacy-policy/
    "smartmove.us" => "compliance@ctam.com", # https://www.smartmove.us/company/privacy
    "socialgist.com" => "contact@socialgist.com", # https://socialgist.com/privacy-policy/
    "statlistics.com" => "privacy@alesco.com", # https://statlistics.com/privacy-policy/
    "studentclearinghouse.org" => "privacy@studentclearinghouse.org", # https://www.studentclearinghouse.org/privacy-policy/
    "telephonelists.biz" => "sales@evs7.com", # https://www.telephonelists.biz/privacy-policy-of-telephonelists-biz/
    "thebridgecorp.com" => "privacy@thebridgecorp.com", # https://www.thebridgecorp.com/privacy-policy/
    "thedma.org" => "privacy@ana.net", # https://www.ana.net/privacy.html
    "towerdata.com" => "privacy@atdata.com", # https://atdata.com/privacy-policy/
    "traversedata.com" => "privacy@traversedata.com", # https://www.traversedata.com/index.html%3Fp=123.html
    "verisk.com" => "info@verisk.com", # https://www.verisk.com/company/contact/
    "viantinc.com" => "privacy@viantinc.com", # https://www.viantinc.com/wp-content/uploads/2024/01/Viant-Privacy-Policy-Platform-1.29.2024-FINAL.pdf
    "visualvisitor.com" => "support@visualvisitor.com", # https://files.elfsightcdn.com/a89e75f3-d14f-4297-bccb-e21fd3d60d03/f5dc35df-4c04-4421-8611-f07678e579bf/Privacy-Policy-v-3-2023-B.pdf
    "wisdommediagroupllc.com" => "contact@wisdommediagroupllc.com" # https://wisdommediagroupllc.com/privacy.php
  }.freeze

  # Stack-ranked list of keywords that indicate the most relevant email address for a
  # list of emails.
  LIKELY_EMAIL_KEYWORDS = %w[
    privacy
    dataprivacy
    dpo
    legal
    compliance
    consumer
    support
    ccpa
    data
    help
    contact
    info
    admin
    hello
  ].freeze

  included do
    before_save :correct_email_if_known!

    scope :with_corrected_email, -> { where(website: VERIFIED_EMAILS_BY_WEBSITE.keys) }
  end

  class_methods do
    # Out of a list of emails, returns the one that is most likely to be the correct
    # one.
    #
    # @param emails [Array<String>]
    # @return [String]
    def most_likely_email(emails)
      likely_email = nil

      LIKELY_EMAIL_KEYWORDS.each do |keyword|
        likely_email = emails.find { |email| email.match?(/#{keyword}.*@/) }
        break if likely_email.present?
      end

      likely_email || emails.first
    end
  end

  # Ensures we're setting the correct email for a company if we've already verified
  # it. This is in place to prevent saving company records with emails that:
  #
  # - Are not valid
  # - Are not the right point person
  # - Are not the right department
  #
  # @return [void]
  def correct_email_if_known!
    verified_email = VERIFIED_EMAILS_BY_WEBSITE.dig(website)
    self.email = verified_email if verified_email.present?
  end
end
