$(function (){
  $("#psdb_gauge").gauge('init',{
    min: 0,
    max: 45,
    unitsLabel: "°",
    label: "Angle",
    colorOfFill: [ '#06c', '#09f', '#d5edf8', '#e5ecf9' ],
    colorOfPointerFill: '#09f',
    colorOfPointerStroke: '#06c'
    });
});

