class  Api::V1::EstablishmentResource <  Api::V1::ApplicationResource
  type :establishments
  model :Establishment

  paginate do |scope, current_page, per_page|
    scope.paginate(page: current_page, per_page: per_page)
  end
end