#Uses gem 'chronic'

def countNumbers(arr)
    count = 0
    for item in arr
        if item =~ /\A[-+]?[0-9:]*\.?[0-9:]+\Z/
            count += 1
        end
    end
    return count
end

def toTime(text)
    if Chronic.parse(text, :now=>Time.now, :guess=>true) != nil
        return Chronic.parse(text, :now=>Time.now, :guess=>true)
    else
        arr = text.split(" ")
        scores = Hash.new
        matches = 0
        for i in 2..[arr.length-1, 4].min
            for start in 0..arr.length-i-1
                combs = arr[start, i+1].combination(i).to_a
                for comb in combs
                    hypothesis = Chronic.parse(comb.join(" "), :now=>Time.now, :guess=>true)
                    if hypothesis != nil
                        if scores[hypothesis] == nil
                            scores[hypothesis] = 0
                        else
                            matches+=1
                        end

                        #Prior belief that Dates on posters are likely NEAR-FUTURE.
                        exotic_time_penalty = 0
                        if hypothesis - Time.now > 800000
                            exotic_time_penalty = 0.2*Math.log10(hypothesis - Time.now - 800000)
                        elsif Time.now - hypothesis > 500000
                            exotic_time_penalty = 0.2*Math.log10(Time.now - hypothesis - 50000)
                        end

                        #Value numbers over words. Penalize hypothesis made from smaller combinations.
                        scores[hypothesis] += i + countNumbers(comb)**2 - exotic_time_penalty
                    end
                end
            end
        end
        scores.each { |k, v| return k if v == scores.values.max }
    end
end

def guess(text)
    print "Guess ", toTime(text), "\n\n"
end

#Tuning:
print "Parsed results:\n\n"

#Training Data:
guess('tomorrow')
guess('4:00 pm Saturday')
guess('4:00 pm Saturday Sep 26')
guess("' 99 wed Sep 23 5:30 PM wed Sep 23 1490 Mon Sep 28 5:30 PM")
guess("Sept. 21 2015 9:30 be 3:30 pm 02368 2015 fall Nov. 15 , 2015")
guess('wed Sept 2 summer winter')
guess('Sunday , October 4th , 2015 today')

#Validation Data:
guess('41 Thursday , September 24 , 2015 current')
guess("TODAY")
guess("SATURDAY , SEP 26")
guess("September 14th")
guess("thursday")

print "End of parsed results"