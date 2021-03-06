class TCRexmlClientTests < Test::Unit::TestCase

  def test_explain
    client = SRU::Client.new 'http://z3950.loc.gov:7090/voyager',:parser=>'rexml'
    explain = client.explain
    assert_equal SRU::ExplainResponse, explain.class
    assert_equal '1.1', explain.version
    assert_equal 'localhost', explain.host
    assert_equal 7090, explain.port
    assert_equal 'voyager', explain.database
    assert_equal 'host=localhost port=7090 database=voyager version=1.1',
      explain.to_s
  end

  def test_search_retrieve
    client = SRU::Client.new 'http://z3950.loc.gov:7090/voyager', :parser=>'rexml'
    results = client.search_retrieve 'twain', :maximumRecords => 5
    assert_equal 5, results.entries.size
    assert results.number_of_records > 2000
    assert_equal REXML::Element, results.entries[0].class
    assert_equal 'recordData', results.entries[0].name

    # hopefully there isn't a document that matches this :)
    results = client.search_retrieve 'fidkidkdiejfl'
    assert_equal 0, results.entries.size
  end

  def test_default_maximum_records
    client = SRU::Client.new 'http://z3950.loc.gov:7090/voyager', :parser=>'rexml'
    results = client.search_retrieve 'twain'
    assert_equal 10, results.entries.size
  end
end


