/*
* WeatherModule
*/

import React from 'react';


export default class WeatherModule extends React.Component { // eslint-disable-line react/prefer-stateless-function

  static propTypes = {
    socket: React.PropTypes.object.isRequired
  };

  constructor(props, context) {
    super(props, context);

    this.state = {
      currentSummary: "",
      currentTemperature: "",
      icon: "",
      location: "",
      weekForecast: [],
      weekSummary: "",
    };
  }

  componentDidMount() {
    const socket = this.props.socket;

    socket.onmessage = (event) => {
      var weather = JSON.parse(event.data).module;
      this.setState(weather.data);
    }
  }

  render() {
    return (
      <div className="col-sm-12">
        <div className="col-sm-12 text-center">
          <h3>
            <i className={this.state.iconClass} ></i> {this.state.currentTemperature}°C <small>{ this.state.location }</small>
          </h3>
          <p>{ this.state.currentSummary }</p>
        </div>
        <div className="col-sm-10 col-sm-offset-1">
          {[...this.state.weekForecast].map((x, i) =>
            <div key={i} className="col-sm-2 text-center">
            <div className="col-sm-12 text-center">
              <p>{x.name}</p>
            </div>
              <div className="col-sm-12">
                <i className={x.iconClass}></i>
              </div>
              <div className="col-sm-12">
                <p>{x.temperature}°C</p>
              </div>
            </div>
          )}
          <div className="col-sm-12 text-center">
            <p>{this.state.weekSummary}</p>
          </div>
        </div>
      </div>
    );
  }
}
