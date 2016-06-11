/*
* WeatherModule
*/

import React from 'react';


export default class WeatherModule extends React.Component { // eslint-disable-line react/prefer-stateless-function

  componentDidMount() {
    // console.log(this.props.weatherData);
  }

  componentWillUnmount() {
  }

  render() {
    return (
      <div className="col-sm-12">
        <div className="col-sm-12 text-center">
        </div>
        <div className="col-sm-12 text-center">
        </div>
      </div>
    );
  }
}
