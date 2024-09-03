import { Line } from 'react-chartjs-2';
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend,
    Filler,
} from 'chart.js';

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend,
    Filler
);

const misoptions = {
    scales : {
        y: {
            min: 0
        },
        x: {
            ticks: { color: 'rgb(255, 99, 132)'}
        }
    }
};

export default function LinesChart({ chartData }) {
    return <Line data={chartData} options={misoptions}/>
}