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
    }
   }
 }
''';

 //Get all launches by pagination
 const getLaunchesByPaginationQuery = '''
 query getLaunchesByPagination(\$offset: Int, \$limit: Int){
 launches(offset: \$offset, limit: \$limit) {
   mission_name
    upcoming
    launch_date_local
    id
    details
    rocket {
      rocket_name
    }
   }
 }
''';


//Get Launch by its id
const getLaunchByIdQuery = '''
 query getLaunchById(\$id: ID!){
  launch(id: \$id){
    mission_name
    upcoming
    launch_date_local
    id
    details
    rocket {
      rocket_name
    }
  }
 }
''';
