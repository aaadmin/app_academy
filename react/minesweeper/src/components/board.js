import React, { Component } from 'react';
import Tile from './tile';

class Board extends Component {

  render(){
    return (
      <div className='board'>
        {this.props.board.grid.map( (row, rowIdx) => {
          return this.renderRows(row, rowIdx);
        }
        )}
      </div>
    );
  }

  renderRows(row, rowIdx){
    return (
      <div className="row" key={`row-${rowIdx}`}>
        {row.map( (tile, tileIdx) => {
          return this.renderTiles(tile, tileIdx, rowIdx);
        })}
      </div>
    );
  }

  renderTiles(tile, rowIdx, tileIdx){
    return (
      <Tile
        key={ `tile-${rowIdx}-${tileIdx}` }
        tile={ tile }
        updateGame={ this.props.updateGame }
      />
    );
  }
}

export default Board;
