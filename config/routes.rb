Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    root to: 'ki2#games'

    get "/:key" => "ki2#games"
    get "/:loc/:year" => "ki2#games"
end

