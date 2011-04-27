require 'helper'

class TestAlibrisSearch < Test::Unit::TestCase
  context "For using the Alibris API, to search: " do
    ### Default limiting parameters are: mtype=B, chunk=25, qsort=r
    setup do
      @default_chunk = 25
      @search = Alibris::Search.new({:api_key => "#{API_KEY}", :output_type => "json"})
    end
#    context "needs an API key" do
#      lambda {
#        client = Alibris::Search.new
#        client.works("kids")
#      }.should raise_error(Exception)
#    end

    context "for all works: " do
      context "by search text" do
        setup do
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wquery=kids", "search_by_wquery.json"
          @wquery = "kids"
          @results = @search.works(@wquery)
        end
        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the title" do
          @results.work.first.title.downcase.should include(@wquery.downcase)
        end
        context "in work: " do
          should "have a property work_id" do
            @results.work.first.should respond_to(:work_id)
            @results.work.first.work_id.should == "3030846"
          end
          should "have a property author" do
            @results.work.first.should respond_to(:author)
            @results.work.first.author.should == "Faber, Adele"
          end
          should "have a property basic" do
            @results.work.first.should respond_to(:basic)
            @results.work.first.basic.should == "Family & Relationships / Parenting / General # Family & Relationships / Conflict Resolution # Family & Relationships / Life Stages / Adolescence"
          end
          should "have a property geo_code" do
            @results.work.first.should respond_to(:geo_code)
            @results.work.first.geo_code.should == "United States"
          end
          should "have a property imageurl" do
            @results.work.first.should respond_to(:imageurl)
            @results.work.first.imageurl.should == "http://images.alibris.com/isbn/9780380570003.gif"
          end
          should "have a property lc_subject" do
            @results.work.first.should respond_to(:lc_subject)
            @results.work.first.lc_subject.should == "Family # Interpersonal communication # Parenting # Secular # United States"
          end
          should "have a property minprice" do
            @results.work.first.should respond_to(:minprice)
            @results.work.first.minprice.should == "0.99"
          end
          should "have a property qty_avail" do
            @results.work.first.should respond_to(:qty_avail)
            @results.work.first.qty_avail.should == "500"
          end
          should "have a property synopsis" do
            @results.work.first.should respond_to(:synopsis)
            @results.work.first.synopsis.should == "A new, updated edition of the popular how-to classic that shows parents how to communicate more effectively with their children. Faber and Mazlish share their latest insights and suggestions based on feedback they've received over the years. Illustrations."
          end
          should "have a property title" do
            @results.work.first.should respond_to(:title)
            @results.work.first.title.should == "How to Talk So Kids Will Listen and Listen So Kids Will Talk"
          end
        end

      end
      context "by author" do
        setup do
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wauth=Dan%20Brown", "search_books_by_wauth.json"
          @results = @search.works(nil, "Dan Brown")
        end

        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the author" do
          @results.work.first.author.should include("Dan", "Brown")
        end
      end
      context "by title" do
        setup do
          @title = "The Fountainhead"
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wtit=The%20Fountainhead", "search_books_by_wtit.json"
          @results = @search.works(nil, nil, @title)
        end

        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the title" do
          @results.work.first.title.downcase.should include(@title.downcase)
        end
      end
      context "by topic: " do
        setup do
          @topic = "photography"
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wtopic=photography", "search_books_by_wtopic.json"
          @results = @search.works(nil, nil, nil, @topic)
        end

        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the basic" do
          @results.work.first.basic.downcase.should include(@topic.downcase)
        end
      end
    end

    context "for books: " do
      context "by search text" do
        context "sorted by rating/price (default)" do
          setup do
            @wquery = "kids"
            stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wquery=kids&mtype=B", "search_by_wquery.json"
            @results = @search.books(@wquery)
          end
          should "return success" do
            @results.message.should eql("Success")
            @results.status.should eql("0")
          end
          should "return atleast one work" do
            @results.work.size.should >= 1
          end
          should "not return more than #{@default_chunk} works" do
            @results.work.size.should_not > @default_chunk
          end
          should "include the parameter in the title" do
            @results.work.first.title.downcase.should include(@wquery.downcase)
          end
        end
        context "sorted by title" do
          setup do
            @wquery = "kids"
            stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wquery=kids&mtype=B&qsort=t", "search_by_wquery_sort_by_title.json"
            @results = @search.books(@wquery, nil, nil, nil, {:qsort => 't'})
          end
          should "return success" do
            @results.message.should eql("Success")
            @results.status.should eql("0")
          end
          should "return atleast one work" do
            @results.work.size.should >= 1
          end
          should "not return more than #{@default_chunk} works" do
            @results.work.size.should_not > @default_chunk
          end
          should "return first book sorted by title" do
            @results.work.first.author.should eql("Tim Podell")
            @results.work.first.title.should eql("\"All About the Book! \" a Kid's Video Guide to Holes (All About the Book)")
            @results.work.first.work_id.should eql("-158543054")
          end
          should "return last book sorted by title" do
            @results.work.last.author.should eql("Scholastic")
            @results.work.last.title.should eql("\"Why Do Leaves Change Color? \" (Questions Kids Ask)")
            @results.work.last.work_id.should eql("-43933782")
          end
        end
        context "sorted by reverse title and limited to 10 records" do
          setup do
            @wquery = "kids"
            @num_records = 10
            stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wquery=kids&mtype=B&qsort=tr&chunk=10", "search_by_wquery_sort_by_reverse_title.json"
            ### Specify number of records to be returned at the query level, rather than in the constructor
            @results = @search.books(@wquery, nil, nil, nil, {:qsort => 'tr', :chunk => @num_records})
          end
          should "return success" do
            @results.message.should eql("Success")
            @results.status.should eql("0")
          end
          should "return atleast one work" do
            @results.work.size.should >= 1
          end
          should "not return more than #{@num_records} works" do
            @results.work.size.should_not > @num_records
          end
          should "return first book sorted by title" do
            @results.work.first.author.should eql("Scoville, Sanny {Designs By}")
            @results.work.first.title.should eql("{Knitting and Crochet} Kids' Fun Vests to Knit and Crochet in Sizes 4 to 14")
            @results.work.first.work_id.should eql("-88195278")
          end
          should "return last book sorted by title" do
            @results.work.last.author.should eql("Warshaw, Hallie")
            @results.work.last.title.should eql("Zany Rainy Days: Indoor Ideas for Active Kids")
            @results.work.last.work_id.should eql("7377616")
          end
        end
        context "limited to 10 records" do
          setup do
            @wquery = "kids"
            @num_records = 10
            ### Specify number of records to be returned in the constructor
            @search_less = Alibris::Search.new({:api_key => "#{API_KEY}", :output_type => "json", :num_results => @num_records})
            stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wquery=kids&mtype=B&chunk=10", "search_by_wquery_sort_by_reverse_title.json"
            @results = @search_less.books(@wquery, nil, nil, nil)
          end
          should "return success" do
            @results.message.should eql("Success")
            @results.status.should eql("0")
          end
          should "return atleast one work" do
            @results.work.size.should >= 1
          end
          should "not return more than #{@num_records} works" do
            @results.work.size.should_not > @num_records
          end
          should "return first book sorted by title" do
            @results.work.first.author.should eql("Scoville, Sanny {Designs By}")
            @results.work.first.title.should eql("{Knitting and Crochet} Kids' Fun Vests to Knit and Crochet in Sizes 4 to 14")
            @results.work.first.work_id.should eql("-88195278")
          end
        end
      end
      context "by author" do
        context "sorted by rating/price (default)" do
          setup do
            stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&mtype=B&wauth=Dan%20Brown", "search_books_by_wauth.json"
            @results = @search.books_by_author("Dan Brown")
          end
          should "return success" do
            @results.message.should eql("Success")
            @results.status.should eql("0")
          end
          should "return atleast one work" do
            @results.work.size.should >= 1
          end
          should "not return more than #{@default_chunk} works" do
            @results.work.size.should_not > @default_chunk
          end
          should "include the parameter in the author" do
            @results.work.first.author.should include("Dan", "Brown")
          end
        end
        context "sorted by title: " do
        setup do
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&mtype=B&wauth=Dan%20Brown&qsort=t", "search_books_by_wauth.json"
          @results = @search.books_by_author("Dan Brown", {:qsort => 't'})
        end

        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the basic" do
          @results.work.first.author.should include("Dan", "Brown")
        end
      end
        context "sorted by title in reverse: " do
        setup do
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&mtype=B&wauth=Dan%20Brown&qsort=tr", "search_books_by_wauth.json"
          @results = @search.books_by_author("Dan Brown", {:qsort => 'tr'})
        end

        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the basic" do
          @results.work.first.author.should include("Dan", "Brown")
        end
      end
      end
      context "by title" do
        setup do
          @title = "The Fountainhead"
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&mtype=B&wtit=The%20Fountainhead", "search_books_by_wtit.json"
          @results = @search.books_by_title(@title)
        end

        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the title" do
          @results.work.first.title.downcase.should include(@title.downcase)
        end
      end
      context "by topic: " do
        context "sorted by rating/price (default)" do
          setup do
            @topic = "photography"
            stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&mtype=B&wtopic=photography", "search_books_by_wtopic.json"
            @results = @search.books_by_topic(@topic)
          end

          should "return success" do
            @results.message.should eql("Success")
            @results.status.should eql("0")
          end
          should "return atleast one work" do
            @results.work.size.should >= 1
          end
          should "not return more than #{@default_chunk} works" do
            @results.work.size.should_not > @default_chunk
          end
          should "include the parameter in the basic" do
            @results.work.first.basic.downcase.should include(@topic.downcase)
          end
        end
      end
   end

    context "for music: " do
      context "by search text" do
        setup do
          @wquery = "kids"
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wquery=kids&mtype=M", "search_by_wquery.json"
          @results = @search.music(@wquery)
        end
        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the title" do
          @results.work.first.title.downcase.should include(@wquery.downcase)
        end
      end
      context "by author" do
        setup do
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&mtype=M&wauth=Cedarmont%20Kids", "search_music_by_wauth.json"
          @results = @search.music_by_author("Cedarmont Kids")
        end
        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the author" do
          @results.work.first.author.should include("Cedarmont", "Kids")
        end
      end
    end

    context "for videos: " do
      context "by search text" do
        setup do
          @wquery = "kids"
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&wquery=kids&mtype=V", "search_by_wquery.json"
          @results = @search.videos(@wquery)
        end
        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the title" do
          @results.work.first.title.downcase.should include(@wquery.downcase)
        end
      end
      context "by title" do
        setup do
          @title = "kids"
          stub_get "http://api.alibris.com/v1/public/search/?outputtype=json&apikey=#{API_KEY}&mtype=V&wtit=kids", "search_videos_by_wtit.json"
          @results = @search.videos_by_title(@title)
        end

        should "return success" do
          @results.message.should eql("Success")
          @results.status.should eql("0")
        end
        should "return atleast one work" do
          @results.work.size.should >= 1
        end
        should "not return more than #{@default_chunk} works" do
          @results.work.size.should_not > @default_chunk
        end
        should "include the parameter in the title" do
          @results.work.first.title.downcase.should include(@title.downcase)
        end
      end
    end

  end


end
