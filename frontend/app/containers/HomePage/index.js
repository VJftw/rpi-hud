/*
* HomePage
*
* This is the first thing users see of our App, at the '/' route
*
* NOTE: while this component should technically be a stateless functional
* component (SFC), hot reloading does not currently support SFCs. If hot
* reloading is not a neccessity for you then you can refactor it and remove
* the linting exception.
*/

import React from 'react';

import ClockModule from '../Modules/ClockModule';
import WeatherModule from '../Modules/WeatherModule';


export default class HomePage extends React.Component { // eslint-disable-line react/prefer-stateless-function

  constructor() {
    super();
    this._socket = new WebSocket("ws://localhost:8080/ws/v1/hud");

    this.moduleData = {};
    this.moduleData.weather = {};
  }

  componentWillMount() {

    // this._socket.onmessage = (event) => {
    //   var data = JSON.parse(event.data);
    //   console.log(data);
    //   var module = data.module;
    //   this.moduleData[module.name] = module.data;
    //   console.log(this.moduleData);
    // }


  }

  render() {
    return (
      <div>
        <div className="col-md-12">
          <div className="col-sm-3"></div>
          <div className="col-sm-6"><ClockModule /></div>
          <div className="col-sm-3"></div>
        </div>
        <div className="col-md-12">
          <WeatherModule {...this.props} socket={this._socket} />
        </div>
      </div>
    );
  }
}
