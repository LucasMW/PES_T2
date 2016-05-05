local function reverse_split(str, pattern)
	local iterator = str:gmatch(pattern)
	local parts = {}
	for part in iterator do
		parts[#parts+1] = part
	end
	return parts
end

local function print_text(word_tuples) -- faz nada
	for i, word_tuple in ipairs(word_tuples) do
		if i > 25 then break end
		print(table.concat(word_tuple, " - "))
	end
	return nil
end

local function sort(words_frequency)
	local word_tuples = {}
	for word, frequency in pairs(words_frequency) do
		word_tuples[#word_tuples+1] = {word, frequency}
	end
	table.sort(word_tuples, function(word_tuple1, word_tuple2)
		return word_tuple1[2] > word_tuple2[2]
	end)
	return word_tuples
end

local function frequencies(word_list)
	local words_frequency = {}
	for i=1, #word_list do
		local word = word_list[i]
		if words_frequency[word] then
			words_frequency[word] = words_frequency[word] + 1
		else
			words_frequency[word] = 1
		end
	end
	return words_frequency
end

local function remove_stop_words(word_list)
	local stop_words_file = assert(io.open("input/stop_words.txt"), "erro na abertura de arquivo de stop_words")
	local stop_words = reverse_split(stop_words_file:read("*all"), "[^,]+")
	for ascii_code=97, 122 do stop_words[#stop_words+1] = string.char(ascii_code) end
	for ascii_code=48, 57 do stop_words[#stop_words+1] = string.char(ascii_code) end
	new_word_list = {}
	for i=1, #word_list do
		local word = word_list[i]
		local are_stop_word = false
		for j=1, #stop_words do
			local stop_word = stop_words[j]
			if word == stop_word then
				are_stop_word = true
				break
			end
		end
		if not are_stop_word then
			new_word_list[#new_word_list+1] = word
		end
	end
	return new_word_list
end

local function scan(str_data)
	return reverse_split(str_data, "%S+")
end

local function filter_chars(str_data)
	return str_data:gsub("[%W_]", " ")
end

local function normalize(str_data)
	return str_data:lower()
end

local function read_file(path_to_file)
	-- lê o arquivo que contém o texto alvo da aplicação
	-- pré-condição a abertura do arquivo está correta
	-- pós-condição o texto extraído tem tamanho maior que 0
	file = assert(io.open(path_to_file), "erro na abertura do arquivo")
	text = file:read("*all")
	assert(#text>0, "error, texto vazio")
	return text
end

print_text(sort(frequencies(remove_stop_words(scan(normalize(filter_chars(read_file("input/words.txt"))))))))
