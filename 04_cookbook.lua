--[[
	Solução no estilo Cookbook, descrito no capítulo 4.

	Este estilo de programação utiliza-se de procedimentos que são executados sequencialmente alterando
	um estado compartilhado entre eles de maneira que ao final tenhamos as informações desejadas.
]]

local text = ""
local words = {}
local word_frequencies = {}

function read_file()
	-- lê o arquivo que contém o texto alvo da aplicação
	-- pré-condição a abertura do arquivo está correta
	-- pós-condição o texto extraído tem tamanho maior que 0
	local file = io.open("input/words.txt")
	text = file:read("*all")
end

function filter_chars_and_normalize()
	-- filtra o texto retirando os Carriage Return , virgulas e pontos
	-- pré condição: texto cru
	-- pós-condição: texto filtrado
	text = string.lower(text)
	text = text:gsub("[%W_]", " ")
end

function scan()
	-- lê stop words, palavras que são vazias de significado
	-- pré-condição, lista de texto com stop words
	-- pós-condição, table com valores de stop words
	for word in text:gmatch("%S+") do
		words[#words+1] = word
	end
 end

function remove_stop_words()
	-- remove stop words do texto
	-- pré-condição: texto filtrado e table de stop_words
	-- pós-condição: texto com palavras removidas 
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

function sorted_frequencies()
	-- conta a quantidade que o texto aparece na busca
	-- pré-cond: texto sem stop words
	-- pós-cond: palavras contadas num array associativo (key, frequencia)
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

	table.sort(word_frequencies, function(word_frequency1, word_frequency2)
		return word_frequency1[2] > word_frequency2[2]
	end)
end

function print_text()
	for i=1, math.min(#word_frequencies, 25)  do
		print(word_frequencies[i][1] .. " " .. word_frequencies[i][2]);
	end
end

read_file()
filter_chars_and_normalize()
scan()
remove_stop_words()
sorted_frequencies()
print_text()
