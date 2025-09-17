// Rocket queries for SpaceX API
// Fetch data about SpaceX rockets

// Get all rockets
const String getAllRocketsQuery = '''
 query getRockets {
  rockets {
    id
    type
    stages
    name
    mass {
      lb
      kg
    }
    diameter {
      meters
      feet
    }
    height {
      meters
      feet
    }
    active
    boosters
    description
    country
    success_rate_pct
    first_flight
    cost_per_launch
    company
  }
 }
''';

//Get rocket by its id
const String getRocketByIdQuery = '''
 query getRocketById(\$id: ID!){
   rocket(id: \$id){
    id
    type
    stages
    name
    mass {
      lb
      kg
    }
    diameter {
      meters
      feet
    }
    height {
      meters
      feet
    }
    active
    boosters
    description
    country
    success_rate_pct
    first_flight
    cost_per_launch
    company
   }
 }
''';
