json.applications @applications do |app|
    json.id app.id
    json.user app.user&.name || app.user&.username 
    json.software app.software
    json.gateway app.gateway
    json.omaha app.omaha
    json.nashville app.nashville
    json.north app.north
    json.buypass app.buypass
    json.elavon app.elavon
    json.tsys app.tsys
    json.source app.source
    json.agent app.agent
    json.created_at app.created_at
    json.updated_at app.updated_at
    json.comments app.comments do |comment|
        json.body comment.body
        json.user comment.user&.name || comment.user&.username
        json.created_at comment.created_at
    end
end
