# Runs the relevant methods to update the companies table with the latest data from
# the California Privacy Protection Agency (CPPA) and DataBrokersWatch.org.
task sync_companies: :environment do
  Company.update_california_data_brokers
  Company.update_data_brokers_watch_companies
end
