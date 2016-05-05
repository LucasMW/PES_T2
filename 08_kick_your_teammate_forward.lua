local function reverse_split(str, pattern)
	local iterator = str:gmatch(pattern)
	local parts = {}
	for part in iterator do
		parts[#parts+1] = part
	end
	return parts
end

local function print_text(word_tuples, do_after) -- faz nada
	for i, word_tuple in ipairs(word_tuples) do
		if i > 25 then break end
		print(table.concat(word_tuple, " - "))
	end
	do_after(nil)
end

local function sort(words_frequency, do_after) -- print_text
	local word_tuples = {}
	for word, frequency in pairs(words_frequency) do
		word_tuples[#word_tuples+1] = {word, frequency}
	end
	table.sort(word_tuples, function(word_tuple1, word_tuple2)
		return word_tuple1[2] > word_tuple2[2]
	end)
	do_after(word_tuples, function() end)
end

local function frequencies(word_list, do_after) -- sort
	local words_frequency = {}
	for i=1, #word_list do
		local word = word_list[i]
		if words_frequency[word] then
			words_frequency[word] = words_frequency[word] + 1
		else
			words_frequency[word] = 1
		end
	end
	do_after(words_frequency, print_text)
end

local function remove_stop_words(word_list, do_after) -- frequencies
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
	do_after(new_word_list, sort)
end

local function scan(str_data, do_after) -- remove_stop_words
	do_after(reverse_split(str_data, "%S+"), frequencies)
end

local function filter_chars(str_data, do_after) -- normalize
	do_after(str_data:gsub("[%W_]", " "), scan)
end

local function normalize(str_data, do_after) -- scan
	do_after(str_data:lower(), remove_stop_words)
end

local function read_file(path_to_file, do_after) -- filter_chars
	-- lê o arquivo que contém o texto alvo da aplicação
	-- pré-condição a abertura do arquivo está correta
	-- pós-condição o texto extraído tem tamanho maior que 0
	file = assert(io.open(path_to_file), "erro na abertura do arquivo")
	text = file:read("*all")
	assert(#text>0, "error, texto vazio")
	do_after(text, normalize)
end

read_file("input/words.txt", filter_chars)
