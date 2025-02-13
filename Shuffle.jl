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

function uniformity_index(deck::Array, number_of_suits::UInt8, size_of_suits::UInt8)::Float64
    optimal_distance = number_of_suits
    distances = []

    Threads.@threads for suit in number_of_suits
        last_card_index = 0
        for card in 1:size_of_suits
            step_from_last_card = 1
            found = false
            while !found
                if last_card_index == 0
                    if deck[step_from_last_card].suit == suit
                        last_card_index = step_from_last_card
                        found = true
                    end
                else
                    if deck[last_card_index + step_from_last_card].suit == suit
                        push!(distances, step_from_last_card)
                        last_card_index += step_from_last_card
                        found = true
                    end
                end

                step_from_last_card += 1
            end
        end
    end

    Threads.@threads for number in size_of_suits
        last_card_index = 0
        for card in 1:size_of_suits
            step_from_last_card = 1
            found = false
            while !found
                if last_card_index == 0
                    if deck[step_from_last_card].number == number
                        last_card_index = step_from_last_card
                        found = true
                    end
                else
                    if deck[last_card_index + step_from_last_card].number == number
                        push!(distances, step_from_last_card)
                        last_card_index += step_from_last_card
                        found = true
                    end
                end
            end
        end
    end
    
    average_distance = sum(distances) / length(distances)

    return average_distance / optimal_distance
end

const number_of_suits::UInt8 = 4
const size_of_suits::UInt8 = 13

deck = generate_deck(number_of_suits, size_of_suits)
println(uniformity_index(deck, number_of_suits, size_of_suits))
