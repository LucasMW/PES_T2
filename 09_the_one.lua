

-- #
-- # The functions
-- #
function read_file(path_to_file)
    -- with open(path_to_file) as f:
    --     data = f.read()
    -- return data
end

function filter_chars(str_data)
    -- pattern = re.compile('[\W_]+')
    -- return pattern.sub(' ', str_data)
end


function normalize(str_data)
    -- return str_data.lower()
end
function scan(str_data)
    -- return str_data.split()
end
function remove_stop_words(word_list)
    -- with open('../stop_words.txt') as f:
    --     stop_words = f.read().split(',')
    -- # add single-letter words
    -- stop_words.extend(list(string.ascii_lowercase))
    -- return [w for w in word_list if not w in stop_words]
end
function frequencies(word_list)
    -- word_freqs = {}
    -- for w in word_list:
    --     if w in word_freqs:
    --         word_freqs[w] += 1
    --     else:
    --         word_freqs[w] = 1
    -- return word_freqs
end
function sort(word_freq)
    -- return sorted(word_freq.iteritems(), key=operator.itemgetter(1), reverse=True)
end
function top25_freqs(word_freqs)
    -- top25 = ""
    -- for tf in word_freqs[0:25]:
    --     top25 += str(tf[0]) + ' - ' + str(tf[1]) + '\n'
    -- return top25
end

-- #
-- # The main function
-- #
-- TFTheOne(sys.argv[1])\
-- .bind(read_file)\
-- .bind(filter_chars)\
-- .bind(normalize)\
-- .bind(scan)\
-- .bind(remove_stop_words)\
-- .bind(frequencies)\
-- .bind(sort)\
-- .bind(top25_freqs)\
-- .printme()