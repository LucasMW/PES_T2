--[[
	Solução no estilo Candy Factory, descrito no capítulo 5.

	Este estilo de programação é derivado do paradigma funcional, onde
	as funções não causam efeito colateral umas sobre as outras, porém
	elas podem ser aninhadas de maneira que o valor retornado em uma
	seja entrada de outra, até que a última função chamada tratará o
	resultado final da maneira mais adequada.
]]

filter_text = (function()
	local function filter_chars(text)
		-- filtra o texto retirando os caracters Return , virgula e ponto
		-- pré-condição o texto extraído tem tamanho maior que 0
		-- pós-condição o texto não contenha return, vigula ou pontos
		return text:gsub("[%W_]", " ")
	end

	local function normalize(text)
		-- transforma todos as letras em minusculas
		-- pré-condição o texto de entrada tenha tamanho maior que 0 
		-- pós-condição o texto não contem letras maiusculas
		return text:lower()
	end

	local function scan(text)
		-- separa a string pelos espaços em uma table de strings menores
		-- pré-condição o texto de entrada tenha tamanho maior que 0 
		-- pós-condição a table tem tamanho maior que 0
		return split(text, "%S+")
	end

	local function remove_stop_words(words)
		-- recebe uma table de strings e retorna uma com as stop words removidas
		-- pré-condição a table tem tamanho maior que 0
		-- pós-condição nenhum valor da table está na lista de stop_words
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

	return function(text)
		return remove_stop_words(scan(normalize(filter_chars(text))))
	end
end)()

function read_file(path_to_file)
	-- lê o arquivo que contém o texto alvo da aplicação
	-- pré-condição a abertura do arquivo está correta
	-- pós-condição o texto extraído tem tamanho maior que 0
	local file = io.open(path_to_file)
	return file:read("*all")
end

function count_frequencies(words)
	-- recebe uma table de indices numeros e valores de strings e retorna uma 
	--  com indices de string e valores representando a frequencia de sua ocorrencia 
	--  na table recebida
	-- pré-condição a table tem tamanho maior que 0
	-- pós-condição a table tem tamanho maior que 0, apenas com valores positivos
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
	return word_frequencies
end

function sort(word_frequencies)
	-- recebe uma table com indices de string e valores representando a frequencia de 
	--  sua ocorrencia e retorna uma table de chaves numericas com as strings e sua
	--  frequencia como valor, ordenada por ordem alfabetica
	-- pré-condição a table tem tamanho maior que 0, apenas com valores positivos
	-- pós-condição a tabela esta ordenada pela string que esta no segundo valor da tupla
	table.sort(word_frequencies, function(word_frequency1, word_frequency2)
		return word_frequency1[2] > word_frequency2[2]
	end)
	return word_frequencies
end

function print_text(word_frequencies) -- faz nada
	-- recebe uma table de chaves numericas com as strings e sua frequencia como
	--  valor, ordenada por ordem alfabetica e imprime na tela as tuplas palavra
	--  frequencia
	-- pré-condição a table tem tamanho maior que 0 e esta ordenada por ordem alfabetica das strings
	-- pós-condição as strings sao impressas na tela com sua frequencia
	for i, word_frequency in ipairs(word_frequencies) do
		if i > 25 then break end
		print(table.concat(word_frequency, " - "))
	end
	return nil
end

function split(str, pattern)
	-- função auxiliar que separa uma string usando pattern
	local iterator = str:gmatch(pattern)
	local parts = {}
	for part in iterator do
		parts[#parts+1] = part
	end
	return parts
end

print_text(sort(count_frequencies(filter_text(read_file("input/text.txt")))))
