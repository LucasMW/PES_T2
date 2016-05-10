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


function filter_chars(str_data, do_after) -- normalize
	-- filtra o texto retirando os caracters Return , virgula e ponto
	-- pré-condição o texto extraído tem tamanho maior que 0
	-- pós-condição o texto não contenha return, vigula ou pontos
	do_after(str_data:gsub("[%W_]", " "), scan)
end

function normalize(str_data, do_after) -- scan
	-- transforma todos as letras em minusculas
	-- pré-condição o texto de entrada tenha tamanho maior que 0 
	-- pós-condição o texto não contem letras maiusculas
	do_after(str_data:lower(), remove_stop_words)
end


function scan(str_data, do_after) -- remove_stop_words
	-- separa a string pelos espaços em uma table de strings menores
	-- pré-condição o texto de entrada tenha tamanho maior que 0 
	-- pós-condição a table tem tamanho maior que 0
	local word_list = reverse_split(str_data, "%S+")
	assert(#word_list>0, "erro, array vazio")
	do_after(word_list, frequencies)
end

function remove_stop_words(word_list, do_after) -- frequencies
	-- recebe uma table de strings e retorna uma com as stop words removidas
	-- pré-condição a table tem tamanho maior que 0
	-- pós-condição nenhum valor da table está na lista de stop_words
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
	for i=1, #new_word_list do
		for j=1, #stop_words do
			assert(new_word_list[i]~=stop_words[j], "erro, stop word não removida")
		end
	end
	do_after(new_word_list, sort)
end

function frequencies(word_list, do_after) -- sort
	-- recebe uma table de indices numeros e valores de strings e retorna uma 
	--  com indices de string e valores representando a frequencia de sua ocorrencia 
	--  na table recebida
	-- pré-condição a table tem tamanho maior que 0
	-- pós-condição a table tem tamanho maior que 0, apenas com valores positivos

	local words_frequency = {}
	for i=1, #word_list do
		local word = word_list[i]
		if words_frequency[word] then
			words_frequency[word] = words_frequency[word] + 1
		else
			words_frequency[word] = 1
		end
	end
	for k, v in ipairs(words_frequency) do
		if k ~= nil then
			assert(v>0, "error, frequencia não positiva")
		end
	end
	do_after(words_frequency, print_text)
end

function sort(words_frequency, do_after) -- print_text
	-- recebe uma table com indices de string e valores representando a frequencia de 
	--  sua ocorrencia e retorna uma table de chaves numericas com as strings e sua
	--  frequencia como valor, ordenada por ordem alfabetica
	-- pré-condição a table tem tamanho maior que 0, apenas com valores positivos
	-- pós-condição a tabela esta ordenada pela string que esta no segundo valor da tupla
	local word_tuples = {}
	for word, frequency in pairs(words_frequency) do
		word_tuples[#word_tuples+1] = {word, frequency}
	end
	table.sort(word_tuples, function(word_tuple1, word_tuple2)
		return word_tuple1[2] > word_tuple2[2]
	end)
	for i=2, #word_tuples do
		assert(word_tuples[i-1][2] > word_truples[i][2], "error, wrong order of strings")
	end
	do_after(word_tuples, function() end)
end

function print_text(word_tuples, do_after) -- faz nada
	-- recebe uma table de chaves numericas com as strings e sua frequencia como
	--  valor, ordenada por ordem alfabetica e imprime na tela as tuplas palavra
	--  frequencia
	-- pré-condição a table tem tamanho maior que 0 e esta ordenada por ordem alfabetica das strings
	-- pós-condição as strings sao impressas na tela com sua frequencia
	for i, word_tuple in ipairs(word_tuples) do
		if i > 25 then break end
		print(table.concat(word_tuple, " - "))
	end
	do_after(nil)
end

function reverse_split(str, pattern)
	-- função auxiliar que separa uma string usando pattern
	local iterator = str:gmatch(pattern)
	local parts = {}
	for part in iterator do
		parts[#parts+1] = part
	end
	return parts
end

read_file("input/words.txt", filter_chars_and_normalize)
