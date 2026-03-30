title: City Gate
underline: ---------
var: trust|0
var: pass|0
var: market_seen|0
var_str: player_name|Unknown

node: intro
speaker: Guard
text: Halt. Why are you here?
choice: I'm a traveler.|traveler
choice_effect: trust|add|1
choice: None of your business.|rude
choice_effect: trust|sub|1
endnode

node: traveler
speaker: Guard
text: Then state your name.
choice: Lena.|name_lena
choice_effect: trust|add|1
choice_effect: pass|set|1
choice_effect_str: player_name|set|Lena
choice: I'd rather not.|refuse_name
choice_effect: trust|sub|1
choice_effect_str: player_name|set|Stranger
endnode

node: rude
speaker: Guard
text: That's the wrong tone for this gate.
choice: Apologize.|traveler
choice_effect: trust|add|1
choice: Double down.|cell
choice_effect: trust|sub|1
endnode

node: name_lena
speaker: Guard
text: {player_name}? I know that name. Your current trust is {trust}. What is your business in the city?
choice: Trade.|gate
choice: Ask for entry without papers.|gate
choice_when: trust|>=|2
choice_when: pass|==|0
choice: Show the merchant pass.|gate
choice_when: pass|==|1
choice_when_str: player_name|==|Lena
choice_effect: trust|add|1
choice: Admit you have no papers.|refuse_name
choice_when: pass|==|0
choice_when: trust|<=|1
choice_effect: trust|sub|1
endnode

node: refuse_name
speaker: Guard
text: No name, no entry.
choice: Leave peacefully.|ending_leave
choice: Argue.|cell
choice_effect: trust|sub|1
endnode

node: gate
speaker: Guard
text: Everything seems in order. You may enter.
choice: Enter the city.|market
endnode

node: cell
speaker: Guard
text: I've heard enough. Take a night in the cell.
choice: Accept your fate.|ending_jail
endnode

node: market
speaker: Narrator
text: You step into the market as the city wakes around you. Steps into market: {market_seen}
node_effect: market_seen|set|1
choice: Finish.|ending_welcome
endnode

node: ending_welcome
ending
ending_text: You earned a warm welcome, {player_name}, with trust {trust}.
endnode

node: ending_jail
ending
ending_text: Your journey stops at the city jail, {player_name}.
endnode

node: ending_leave
ending
ending_text: You leave the gate behind and try elsewhere, {player_name}.
endnode
