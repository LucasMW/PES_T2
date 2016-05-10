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

function read_file(path_to_file, continuation) -- filter_chars
	-- lê o arquivo que contém o texto alvo da aplicação
	-- pré-condição a abertura do arquivo está correta
	-- pós-condição o texto extraído tem tamanho maior que 0
	local file = io.open(path_to_file)
	continuation(file:read("*all"), scan)
end

function filter_chars_and_normalize(text, continuation) -- scan
	-- transforma todos as letras em minusculas
	-- pré-condição o texto de entrada tenha tamanho maior que 0 
	-- pós-condição o texto não contem letras maiusculas
	-- 
	-- filtra o texto retirando os caracters Return , virgula e ponto
	-- pré-condição o texto extraído tem tamanho maior que 0
	-- pós-condição o texto não contenha return, vigula ou pontos
	continuation(text:lower():gsub("[%W_]", " "), remove_stop_words)
end

function scan(text, continuation) -- remove_stop_words

	local words = split(text, "%S+")
	assert(#words>0, "erro, array vazio")
	continuation(words, sorted_frequencies)
end

function remove_stop_words(words, continuation) -- sorted_frequencies
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
	for i, word in ipairs(new_words) do
		for j, stop_word in ipairs(stop_words) do
			assert(word ~= stop_word, "erro, stop word não removida")
		end
	end
	continuation(new_words, print_text)
end

function sorted_frequencies(words, continuation) -- print_text
	-- recebe uma table de indices numeros e valores de strings e retorna uma 
	--  com indices de string e valores representando a frequencia de sua ocorrencia 
	--  na table recebida
	-- pré-condição a table tem tamanho maior que 0
	-- pós-condição a table tem tamanho maior que 0, apenas com valores positivos
	-- 
	-- recebe uma table com indices de string e valores representando a frequencia de 
	--  sua ocorrencia e retorna uma table de chaves numericas com as strings e sua
	--  frequencia como valor, ordenada por ordem alfabetica
	-- pré-condição a table tem tamanho maior que 0, apenas com valores positivos
	-- pós-condição a tabela esta ordenada pela string que esta no segundo valor da tupla
	local words_frequency = {}
	for i=1, #words do
		local word = words[i]
		if words_frequency[word] then
			words_frequency[word] = words_frequency[word] + 1
		else
			words_frequency[word] = 1
		end
	end

	local word_frequencies = {}
	for word, frequency in pairs(words_frequency) do
		word_frequencies[#word_frequencies+1] = {word, frequency}
	end
	table.sort(word_frequencies, function(word_frequency1, word_frequency2)
		return word_frequency1[2] > word_frequency2[2]
	end)
	for i,word_frequency in ipairs(word_frequencies) do
		assert(word_frequency[2]>0, "error, frequencia não positiva")
	end
	for i=2, #word_frequencies do
		assert(word_frequencies[i-1][2] >= word_frequencies[i][2], "erro, palavras não foram ordenadas por sua frequencia")
	end
	continuation(word_frequencies, function() end)
end

function print_text(word_frequencies, continuation) -- faz nada
	-- recebe uma table de chaves numericas com as strings e sua frequencia como
	--  valor, ordenada por ordem alfabetica e imprime na tela as tuplas palavra
	--  frequencia
	-- pré-condição a table tem tamanho maior que 0 e esta ordenada por ordem alfabetica das strings
	-- pós-condição as strings sao impressas na tela com sua frequencia
	for i, word_frequency in ipairs(word_frequencies) do
		if i > 25 then break end
		print(table.concat(word_frequency, " - "))
	end
	continuation(nil)
end

function split(str, pattern)
	-- função auxiliar que separa uma string usando pattern
	local parts = {}
	for part in str:gmatch(pattern) do
		parts[#parts+1] = part
	end
	return parts
end

read_file("input/words.txt", filter_chars_and_normalize)
