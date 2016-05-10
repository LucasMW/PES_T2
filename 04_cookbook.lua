--[[
	Solução no estilo Cookbook, descrito no capítulo 4.

	Este estilo de programação utiliza-se de procedimentos que são executados sequencialmente alterando
	um estado compartilhado entre eles de maneira que ao final tenhamos as informações desejadas.
]]

local text = ""
local words = {}
local word_frequencies = {}

filter_text = (function()
	local function filter_chars()
		-- filtra o texto retirando os caracters Return , virgula e ponto
		-- pré-condição o texto extraído tem tamanho maior que 0
		-- pós-condição o texto não contenha return, vigula ou pontos
		text = text:gsub("[%W_]", " ")
	end

	local function normalize()
		-- transforma todos as letras em minusculas
		-- pré-condição o texto de entrada tenha tamanho maior que 0 
		-- pós-condição o texto não contem letras maiusculas
		text = string.lower(text)
	end

	local function scan()
		-- Divide o texto em um vetor de palavras
		-- pré-condição: um texto filtrado e lowercase, porém em única string
		-- pós-condição, uma lista de palavras que compõem o texto.
		for word in text:gmatch("%S+") do
			words[#words+1] = word
		end
	 end

	local function remove_stop_words()
		-- recebe uma table de strings e retorna uma com as stop words removidas
		-- pré-condição a table tem tamanho maior que 0
		-- pós-condição nenhum valor da table está na lista de stop_words
		local file = io.open("input/stop_words.txt")
		local stop_words_text = file:read("*all")
		for stop_word in string.gmatch(stop_words_text, "[^,]+") do
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
		words = new_words
	end

	return function()
		filter_chars()
		normalize()
		scan()
		remove_stop_words()
	end
end)()

function read_file()
	-- lê o arquivo que contém o texto alvo da aplicação
	-- pré-condição a abertura do arquivo está correta
	-- pós-condição o texto extraído tem tamanho maior que 0
	local file = io.open("input/words.txt")
	text = file:read("*all")
end

function count_frequencies()
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

	for word, frequency in pairs(frequency_hash) do
		word_frequencies[#word_frequencies+1] = {word, frequency}
	end
end

function sort()
	-- recebe uma table com indices de string e valores representando a frequencia de 
	--  sua ocorrencia e retorna uma table de chaves numericas com as strings e sua
	--  frequencia como valor, ordenada por ordem alfabetica
	-- pré-condição a table tem tamanho maior que 0, apenas com valores positivos
	-- pós-condição a tabela esta ordenada pela string que esta no segundo valor da tupla
	table.sort(word_frequencies, function(word_frequency1, word_frequency2)
		return word_frequency1[2] > word_frequency2[2]
	end)
end

function print_text()
	-- recebe uma table de chaves numericas com as strings e sua frequencia como
	--  valor, ordenada por ordem alfabetica e imprime na tela as tuplas palavra
	--  frequencia
	-- pré-condição a table tem tamanho maior que 0 e esta ordenada por ordem alfabetica das strings
	-- pós-condição as strings sao impressas na tela com sua frequencia
	for i=1, math.min(#word_frequencies, 25)  do
		print(word_frequencies[i][1] .. " " .. word_frequencies[i][2]);
	end
end

read_file()
filter_text()
count_frequencies()
sort()
print_text()
