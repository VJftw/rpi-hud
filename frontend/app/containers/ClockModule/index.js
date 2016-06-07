/*
* ClockModule
*/

import React from 'react';

export default class ClockModule extends React.Component { // eslint-disable-line react/prefer-stateless-function

  constructor() {
    super();

    this.state = {
      timeFormatted: this.getFormattedTime(),
    };

    this.timer = null;
  }

  componentDidMount() {
    this.timer = setInterval(() => {
      this.setState({
        timeFormatted: this.getFormattedTime(),
      });
    }, 1000);
  }

  componentWillUnmount() {
    clearInterval(this.timer);
  }

  getFormattedTime() {
    return new Date().toLocaleString();
  }

  render() {
    return (
      <div className="col-md-12">
        <h1>
          {this.state.timeFormatted}
        </h1>
      </div>
    );
  }
}
