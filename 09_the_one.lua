
--[[
    Solução no estilo The One , descrito no capítulo 9.
    Existe uma abstração que guarda e envolve os valores,
    se liga às funções para operar os valores e no fim, libera o resultado final.
    Isso faz o problema maior ser resolvido por uma cascata de funções(uma sob o retorno da outra),
    exportando o resultado final ao término das operações.
]]

TFTheOne = { value=0 }

-- função que liga as funções externas para um funcionamento em cascata
 function TFTheOne.bind(self,func)
        self.value = func(self.value)
        return self
 end

-- função que exporta o resultado final do processamento
 function TFTheOne.printme(self)

    -- exporta o resultado de forma visível ao usuário da aplicação
    -- pré-cond: array de 25 strings no formato palavra - frequencia
    -- pós-cond: valores do array devidamente printados no console
        for i=1 , #self.value do
            print(self.value[i] ) 
        end
 end

--  
--  Funções Externas
-- 

function read_file(path_to_file)
    -- lê o arquivo que contém o texto alvo da aplicação
    -- pré-condição a abertura do arquivo está correta
    -- pós-condição o texto extraído tem tamanho maior que 0
    local file = io.open(path_to_file, "r")
    local data = file:read("*all")
    return data
end

function filter_text(str_data)
    -- Filtra o texto, tornando-o pronto para a análise de frequência
    -- pré condição: texto cru
    -- pós-condição: texto filtrado. Pronto para a análise de frequência
    local text = filter_chars(str_data)
    text = normalize(text)
    local words = scan(text)
    local new_words = remove_stop_words(words)
    return new_words

end

function filter_chars(str_data)
    -- filtra o texto retirando os Carriage Return , virgulas e pontos
    -- pré condição: texto cru
    -- pós-condição: texto filtrado. Sem caracteres especiais.
    local text = str_data:gsub("[%W_]", " ")
    return text
end


function normalize(str_data)
    -- Normaliza a string para problemas de sensitividade de caixa
    -- pré condição: texto filtrado porém sensível à caixa
    -- pós-condição: texto filtrado, em lowercase.
    return string.lower(str_data)
end

function scan(text)
    -- Divide o texto em uma lista de palavras
    -- pré-condição: um texto filtrado e lowercase, porém em única string
    -- pós-condição, uma lista de palavras que compõem o texto.
    local words = {}
    for word in text:gmatch("%S+") do
        words[#words+1] = word
    end
    return words
end

function remove_stop_words(words)
    -- remove stop words do texto
    -- pré-condição: texto filtrado e table de stop_words
    -- pós-condição: texto com palavras removidas 
    local file = io.open('input/stop_words.txt', "r") 
    local stop_words = file:read("*all")
    

    for stop_word in string.gmatch(stop_words, "[^,]+") do
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
    return new_words
    -- stop_words.extend(list(string.ascii_lowercase))
    -- return [w for w in word_list if not w in stop_words]
end
function frequencies(words)
    -- conta a quantidade que o texto aparece na busca
    -- pré-cond: texto sem stop words
    -- pós-cond: palavras contadas num array associativo (key, frequencia)
   local frequency_hash = {}
   local word_frequencies = {}
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
    return word_frequencies
end
function sort(word_frequencies)
    -- conta a quantidade que o texto aparece na busca
    -- pré-cond: texto sem stop words
    -- pós-cond: palavras contadas num array associativo (key, frequencia)
     table.sort(word_frequencies, function(word_frequency1, word_frequency2)
        return word_frequency1[2] > word_frequency2[2]
    end)
     return word_frequencies
end
function top25_freqs(word_frequencies)
    -- consegue as 25 palavras mais frequentes
    -- pré-cond: array associativo (key,frequencia) ordenado
    -- pós-cond: array de 25 strings no formato palavra - frequencia
    top25 = {}
    for i=1, math.min(#word_frequencies, 25)  do
        top25[i] = word_frequencies[i][1] .. " - " .. word_frequencies[i][2]
    end
    return top25
end

-- 
-- 
--  A função principal (main)
-- 

    TFTheOne.value = arg[1]
    print(arg[1])
    TFTheOne:bind(read_file)
    TFTheOne:bind(filter_text)
    TFTheOne:bind(frequencies)
    TFTheOne:bind(sort)
    TFTheOne:bind(top25_freqs)
    TFTheOne:printme()
