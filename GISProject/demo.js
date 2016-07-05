/**
 * Particleground demo
 * @author Jonathan Nicol - @mrjnicol
 */

document.addEventListener('DOMContentLoaded', function () {
  particleground(document.getElementById('particles'), {
    dotColor: '#64FFDA',
    lineColor: '#64FFDA',
    maxSpeedX: '0.1',
    maxSpeedY: '0.1',
  });
}, false);
