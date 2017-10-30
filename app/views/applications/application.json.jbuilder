json.application do
    json.id @application.id
    json.user @application.user&.name || @application.user&.username 
    json.software @application.software
    json.gateway @application.gateway
    json.omaha @application.omaha
    json.nashville @application.nashville
    json.north @application.north
    json.buypass @application.buypass
    json.elavon @application.elavon
    json.tsys @application.tsys
    json.source @application.source
    json.agent @application.agent
    json.notes @application.notes
    json.created_at @application.created_at
    json.updated_at @application.updated_at
    json.comments @application.comments do |comment|
        json.body comment.body
        json.user comment.user&.name || comment.user&.username
        json.created_at comment.created_at
    end
end
