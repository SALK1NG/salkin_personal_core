Config = {
    language = 'en',
    color = { r = 230, g = 230, b = 230, a = 255 }, -- Text color
    font = 7, -- Text font
    time = 5000, -- Duration to display the text (in ms)
    scale = 0.5, -- Text scale
    dist = 250, -- Min. distance to draw 
}

Config.stunShouldRagdoll = true;    -- If tased, enable our ragdoll to make them toggle to "get up"

-- Languages available
Languages = {
    ['en'] = {
        commandName = 'me',
        commandDescription = 'Zeigen Sie eine Aktion über Ihrem Kopf an.',
        commandSuggestion = {{ name = 'action', help = '„Kratzt seine Nase“ zum Beispiel.'}},
        prefix = ' '
    },
    ['fr'] = {
        commandName = 'me',
        commandDescription = 'Affiche une action au dessus de votre tête.',
        commandSuggestion = {{ name = 'action', help = '"se gratte le nez" par exemple.'}},
        prefix = 'l\'individu '
    },
    ['dk'] = {
        commandName = 'me',
        commandDescription = 'Viser en handling over hovedet.',
        commandSuggestion = {{ name = 'Handling', help = '"Tager en smøg op ad lommen" for eksempel.'}},
        prefix = 'Personen '
    },
}
