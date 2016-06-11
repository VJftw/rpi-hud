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
          <h2>{this.state.time.format('HH:mm')}</h2>
        </div>
        <div className="col-sm-12 text-center">
          <h4>{this.state.time.format('dddd, Do MMMM YYYY')}</h4>
        </div>
      </div>
    );
  }
}
