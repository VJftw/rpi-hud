/*
* WeatherModule
*/

import React from 'react';


export default class WeatherModule extends React.Component { // eslint-disable-line react/prefer-stateless-function

  static propTypes = {
    moduleData: React.PropTypes.object.isRequired,
    layout: React.PropTypes.string,
  };

  constructor(props, context) {
    super(props, context);

    this.state = props.moduleData.weather;
  }

  componentWillReceiveProps(newProps) {
    if (newProps.moduleData.hasOwnProperty('weather')) {
      this.setState(newProps.moduleData.weather);
    }
  }

  render() {
    if (!this.state || !this.state.hasOwnProperty('currentSummary')) {
      return (<div></div>);
    } else if (this.props.hasOwnProperty('layout') && this.props.layout === 'heading') {
      return (
        <div className="col-xs-12 text-right">
          <h4><i className={this.state.iconClass} ></i> {this.state.currentTemperature}°C <small>{this.state.location}</small></h4>
        </div>
      );
    }
    return (
      <div className="col-sm-12">
        <div className="col-sm-12 text-center">
          <h3>
            <i className={this.state.iconClass} ></i> {this.state.currentTemperature}°C <small>{this.state.location}</small>
          </h3>
          <p>{this.state.currentSummary}</p>
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
