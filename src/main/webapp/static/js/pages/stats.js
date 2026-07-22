/**
 * Stats page — progress bar initialization and Chart.js rendering.
 * Data is passed via data-* attributes set by the JSP (no inline script for chart config).
 */
(function() {
    'use strict';

    window.StatsPage = {
        initProgressBars: function() {
            var bars = document.querySelectorAll('.progress-bar');
            bars.forEach(function(bar) {
                var width = bar.getAttribute('data-width');
                if (width) {
                    bar.style.width = width + '%';
                }
            });
        },

        initTrendChart: function(labels, data) {
            var chartEl = document.getElementById('borrowTrendChart');
            if (!chartEl || typeof Chart === 'undefined') return;

            var ctx = chartEl.getContext('2d');
            var gradient = ctx.createLinearGradient(0, 0, 0, 300);
            gradient.addColorStop(0, 'rgba(54, 87, 124, 0.35)');
            gradient.addColorStop(1, 'rgba(54, 87, 124, 0.01)');

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '借阅次数',
                        data: data,
                        borderColor: '#36577c',
                        backgroundColor: gradient,
                        borderWidth: 3,
                        pointBackgroundColor: '#36577c',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            labels: { font: { family: 'inherit', size: 13, weight: '600' } }
                        }
                    },
                    scales: {
                        x: { grid: { display: false } },
                        y: {
                            beginAtZero: true,
                            grid: { color: 'rgba(226, 232, 240, 0.6)' },
                            ticks: {
                                stepSize: 1,
                                font: { family: 'inherit', size: 12 }
                            }
                        }
                    }
                }
            });
        }
    };

    document.addEventListener('DOMContentLoaded', function() {
        window.StatsPage.initProgressBars();
    });
})();
