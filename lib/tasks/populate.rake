namespace :utils do
  task(:populate => [:environment, :fetch]) do
    Fetcher.populate
  end
  task(:fetch) do
    Fetcher.fetch
  end
end
