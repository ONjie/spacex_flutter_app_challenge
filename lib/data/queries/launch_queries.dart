// Launch queries for SpaceX API
// Fetch data about SpaceX launches

//Get all Launches
const String getLaunchesQuery = '''
 query getLaunches {
  launches {
   mission_name
    upcoming
    launch_date_local
    id
    details
    rocket {
      rocket_name
      rocket_type
    }
    launch_year
   }
 }
''';


//Get Launch by its id
const getLaunchByIdQuery = '''
 query getLaunchById(\$id: ID!){
  launchpad(id: \$id){
    mission_name
    upcoming
    launch_date_local
    id
    details
    rocket {
      rocket_name
      rocket_type
    }
    launch_year
  }
 }
''';
