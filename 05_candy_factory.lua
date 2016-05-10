--[[
	Solução no estilo Candy Factory, descrito no capítulo 5.

	Este estilo de programação é derivado do paradigma funcional, onde
	as funções não causam efeito colateral umas sobre as outras, porém
	elas podem ser aninhadas de maneira que o valor retornado em uma
	seja entrada de outra, até que a última função chamada tratará o
	resultado final da maneira mais adequada.
]]

function read_file(path_to_file)
	-- lê o arquivo que contém o texto alvo da aplicação
	-- pré-condição a abertura do arquivo está correta
	-- pós-condição o texto extraído tem tamanho maior que 0
	local file = io.open(path_to_file)
	return file:read("*all")
end

function filter_chars_and_normalize(str_data)
	return str_data:lower():gsub("[%W_]", " ")
end

function scan(text)
	return split(text, "%S+")
end

function remove_stop_words(words)
	local file = io.open("input/stop_words.txt")
	local stop_words = split(file:read("*all"), "[^,]+")
	for ascii_code=97, 122 do stop_words[#stop_words+1] = string.char(ascii_code) end
	for ascii_code=48, 57 do stop_words[#stop_words+1] = string.char(ascii_code) end

	local new_words = {}
	for i,word in ipairs(words) do
		local are_stop_word = false
		for j,stop_word in ipairs(stop_words) do
			if word == stop_word then
				are_stop_word = true
				break
			end
		end
		if not are_stop_word then
			new_words[#new_words+1] = word
		end
	end
	return new_words
end

function sorted_frequencies(words)
	local frequency_hash = {}
	for i,word in ipairs(words) do
		if frequency_hash[word] then
			frequency_hash[word] = frequency_hash[word] + 1
		else
			frequency_hash[word] = 1
		end
	end

	local word_frequencies = {}
	for word, frequency in pairs(frequency_hash) do
		word_frequencies[#word_frequencies+1] = {word, frequency}
	end
	table.sort(word_frequencies, function(word_frequency1, word_frequency2)
		return word_frequency1[2] > word_frequency2[2]
	end)
	return word_frequencies
end

function print_text(word_frequencies) -- faz nada
	for i, word_frequency in ipairs(word_frequencies) do
		if i > 25 then break end
		print(table.concat(word_frequency, " - "))
	end
	return nil
end

function split(str, pattern)
	local iterator = str:gmatch(pattern)
	local parts = {}
	for part in iterator do
		parts[#parts+1] = part
	end
	return parts
end

print_text(sorted_frequencies(remove_stop_words(scan(filter_chars_and_normalize(read_file("input/words.txt"))))))
