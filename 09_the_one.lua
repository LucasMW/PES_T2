

TFTheOne = { value=0 }


 function TFTheOne.init(self, v)
        self.value = v
 end


 function TFTheOne.bind(self,func)
        self.value = func(self.value)
        return self
 end


 function TFTheOne.printme(self)
        for i=1 , #self.value do
            print(self.value[i] ) 
        end
 end
-- # 
-- # The functions
-- #
function read_file(path_to_file)
    local file = io.open(path_to_file, "r")
    local data = file:read("*all")
    return data
end

function filter_chars(str_data)
    local text = str_data:gsub("[%W_]", " ")
    return text
end


function normalize(str_data)
    return string.lower(str_data)
end
function scan(text)
    local words = {}
    for word in text:gmatch("%S+") do
        words[#words+1] = word
    end
    return words
end
function remove_stop_words(words)
    local file = io.open('input/stop_words.txt', "r") 
    local stop_words = file:read("*all")
    

    for stop_word in string.gmatch(stop_words, "[^,]+") do
        for i=1, #words do
            if words[i] == stop_word then
                words[i] = ""
            end
        end
    end

    for i=1, #words do
        if #words[i] == 1 then
            words[i] = nil
        end
    end

    local new_words = {}
    for i,word in pairs(words) do
        if word ~= "" then
            new_words[#new_words+1] = word
        end
    end
    return new_words
    -- stop_words.extend(list(string.ascii_lowercase))
    -- return [w for w in word_list if not w in stop_words]
end
function frequencies(words)
   local frequency_hash = {}
   local word_frequencies = {}
    for i,word in ipairs(words) do
        if frequency_hash[word] then
            frequency_hash[word] = frequency_hash[word] + 1
        else
            frequency_hash[word] = 1
        end
    end

    for word, frequency in pairs(frequency_hash) do
        word_frequencies[#word_frequencies+1] = {word, frequency}
    end
    return word_frequencies
end
function sort(word_frequencies)
     table.sort(word_frequencies, function(word_frequency1, word_frequency2)
        return word_frequency1[2] > word_frequency2[2]
    end)
     return word_frequencies
end
function top25_freqs(word_frequencies)
    top25 = {}
    for i=1, math.min(#word_frequencies, 25)  do
        top25[i] = word_frequencies[i][1] .. " - " .. word_frequencies[i][2]
    end
    return top25
end


-- #
-- # The main function
-- #

    TFTheOne.value = arg[1]
    print(arg[1])
    TFTheOne:bind(read_file)
    TFTheOne:bind(filter_chars)
    TFTheOne:bind(normalize) 
    TFTheOne:bind(scan)
    TFTheOne:bind(remove_stop_words)
    TFTheOne:bind(frequencies)
    TFTheOne:bind(sort)
    TFTheOne:bind(top25_freqs)
    TFTheOne:printme()
