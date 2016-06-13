/*
* ClockModule
*/

import React from 'react';
import moment from 'moment';


export default class ClockModule extends React.Component { // eslint-disable-line react/prefer-stateless-function

  constructor() {
    super();

    this.state = {
      time: moment(),
    };

    this.timer = null;
  }

  componentDidMount() {
    this.timer = setInterval(() => {
      this.setState({
        time: moment(),
      });
    }, 1000);
  }

  componentWillUnmount() {
    clearInterval(this.timer);
  }

  render() {
    return (
      <div className="col-sm-12">
        <div className="col-sm-12 text-center">
          <h2>{this.state.time.format('HH:mm')}<sub><small>{this.state.time.format('ss')}</small></sub></h2>
        </div>
        <div className="col-sm-12 text-center">
          <h5>{this.state.time.format('dddd, Do MMMM YYYY')}</h5>
        </div>
      </div>
    );
  }
}
