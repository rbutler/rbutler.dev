---
layout: post
title:  "Testing Faraday retries with WebMock"
tags: [ruby,testing]
---
We use [Faraday](https://github.com/lostisland/faraday) extensively for our making HTTP requests. We rely on [WebMock](https://github.com/bblimke/webmock) to stub our these requests in rspec. We started encountering some timeout issues, and wanted to provide some retries without relying on a worker system.  Fortunately, **Faraday** builds this in.

``` ruby
connection = Faraday.new do |config|
  config.request :retry, max: 2
end
```

Of course, I wanted to test this functionaltiy, which proved to be less than obvious.  Fortunately, I discovered the `to_timeout` method stub.  I was able to create the following two specs, which rely on the ability to chain methods in **WebMock** for subsequent calls.

``` ruby
before do
  class Foo 
    def self.root
      response = connection.get("/")
      response.status
    end
  end
end

context "retries twice" do
it "succeeds after 2 timeouts" do
  stub_request(:get, stub_url)
    .to_timeout
    .to_timeout
    .to_return(status: 200)

  expect {
    Foo.new.root
  }.not_to raise_error
end

it "fails after 3 timeouts" do
  stub_request(:get, stub_url)
    .to_timeout
    .to_timeout
    .to_timeout
    .to_return(status: 200)

  expect {
    Foo.new.root
  }.to raise_error
end
```

It is nice to be able to test all aspects of our application, including configuration of a library.
