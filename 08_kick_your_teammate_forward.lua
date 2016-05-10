--[[
	Solução no estilo Kick your teammate forward, descrito no capítulo 8.

	Este estilo de programação é uma variação do Candy Factory, porém usando
	o Continuous Passing Style, que é um estilo de programação funcional onde
	nenhuma função retorna valor, porém sempre recebe outra função como parâmetro.
	Esta função recebida como argumento será executada passando o resultado da
	função corrente.

	Tal técnica é útil na implementação de compiladores ou interpretadores, pois
	ela dá total controle sobre o fluxo de execução já que à qualquer momento uma
	função pode ignorar a função de continuação e mudar o fluxo de execução.
]]

function read_file(path_to_file, do_after) -- filter_chars
	-- lê o arquivo que contém o texto alvo da aplicação
	-- pré-condição a abertura do arquivo está correta
	-- pós-condição o texto extraído tem tamanho maior que 0
	file = assert(io.open(path_to_file), "erro na abertura do arquivo")
	text = file:read("*all")
	assert(#text>0, "error, texto vazio")
	do_after(text, scan)
end

function filter_chars_and_normalize(str_data, do_after) -- scan
	do_after(str_data:lower():gsub("[%W_]", " "), remove_stop_words)
end

function scan(str_data, do_after) -- remove_stop_words
	do_after(reverse_split(str_data, "%S+"), sorted_frequencies)
end

function remove_stop_words(word_list, do_after) -- sorted_frequencies
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
	do_after(new_word_list, print_text)
end

function sorted_frequencies(word_list, do_after) -- print_text
	local words_frequency = {}
	for i=1, #word_list do
		local word = word_list[i]
		if words_frequency[word] then
			words_frequency[word] = words_frequency[word] + 1
		else
			words_frequency[word] = 1
		end
	end

	local word_tuples = {}
	for word, frequency in pairs(words_frequency) do
		word_tuples[#word_tuples+1] = {word, frequency}
	end
	table.sort(word_tuples, function(word_tuple1, word_tuple2)
		return word_tuple1[2] > word_tuple2[2]
	end)
	do_after(word_tuples, function() end)
end

function print_text(word_tuples, do_after) -- faz nada
	for i, word_tuple in ipairs(word_tuples) do
		if i > 25 then break end
		print(table.concat(word_tuple, " - "))
	end
	do_after(nil)
end

function reverse_split(str, pattern)
	local iterator = str:gmatch(pattern)
	local parts = {}
	for part in iterator do
		parts[#parts+1] = part
	end
	return parts
end

read_file("input/words.txt", filter_chars_and_normalize)
