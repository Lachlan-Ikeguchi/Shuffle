using Random

struct card
    suit
    number
end

function generate_deck(number_of_suits::UInt8, size_of_suits::UInt8)::Array
    deck = []

    for suit in 1:number_of_suits
        for number in 1:size_of_suits
            push!(deck, card(suit, number))
        end
    end

    return deck
end

function perfect_deck(number_of_suits::UInt8, size_of_suits::UInt8)::Array
    deck = []

    for number in 1:size_of_suits
        for suit in 1:number_of_suits
            push!(deck, card(suit, number))
        end
    end

    return deck
end

function uniformity_index(deck::Array, number_of_suits::UInt8, size_of_suits::UInt8)::Float64
    optimal_distance_suits = number_of_suits
    optimal_distance_numbers = size_of_suits
    distances_suits = Vector{Int}(undef, (number_of_suits * (size_of_suits - 1)))
    distances_numbers = Vector{Int}(undef, (size_of_suits * (number_of_suits - 1)))

    Threads.@threads for suit in 1:number_of_suits
        last_card_index = 0
        for number in 1:size_of_suits
            step_from_last_card = 1
            found = false
            while !found
                if last_card_index == 0
                    if deck[step_from_last_card].suit == suit
                        last_card_index = step_from_last_card
                        found = true
                    end
                else
                    if deck[last_card_index+step_from_last_card].suit == suit
                        distances_suits[suit+number] = round(step_from_last_card) 
                        last_card_index += step_from_last_card
                        found = true
                        println(distances_suits[suit+number])
                    end
                end

                step_from_last_card += 1
            end
        end
    end

    Threads.@threads for number in 1:size_of_suits
        last_card_index = 0
        for suit in 1:number_of_suits
            step_from_last_card = 1
            found = false
            while !found
                if last_card_index == 0
                    if deck[step_from_last_card].number == number
                        last_card_index = step_from_last_card
                        found = true
                    end
                else
                    if deck[last_card_index+step_from_last_card].number == number
                        distances_numbers[number+suit] = round(step_from_last_card)
                        last_card_index += step_from_last_card
                        found = true
                        println(distances_numbers[suit+number])
                    end
                end

                step_from_last_card += 1
            end
        end
    end
    
    println(distances_suits, "\n")
    println(distances_numbers, "\n")

    suit_index = (sum(distances_suits) / length(distances_suits)) / optimal_distance_suits
    number_index = (sum(distances_numbers) / length(distances_numbers)) / optimal_distance_numbers

    return suit_index * number_index
end

const number_of_suits::UInt8 = 4
const size_of_suits::UInt8 = 13

deck = generate_deck(number_of_suits, size_of_suits)
println(deck, "\n")
index = uniformity_index(deck, number_of_suits, size_of_suits)
println(index)

# perfect = perfect_deck(number_of_suits, size_of_suits)
# println(uniformity_index(perfect, number_of_suits, size_of_suits))

# shuffled = Random.shuffle(deck)
# println(uniformity_index(shuffled, number_of_suits, size_of_suits))
