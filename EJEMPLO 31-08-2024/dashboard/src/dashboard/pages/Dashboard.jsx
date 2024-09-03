import { useEffect, useState } from "react";
import LinesChart from "../components/LinesChart"
import proyecto1Api from "../../api/proyecto1";

export const Dashboard = () => {

    const [lineChart, setLineChart] = useState(null);

    const fetchData = async () => {
        try {
            const { data } = await proyecto1Api.get('/data');
            console.log(data);

            const midata = {
                labels: data.hora,
                datasets: [ // Cada una de las líneas del gráfico
                    {
                        label: data.dia,
                        data: data.temperaturas,
                        tension: 0.5,
                        fill : true,
                        borderColor: 'rgb(255, 99, 132)',
                        backgroundColor: 'rgba(255, 99, 132, 0.5)',
                        pointRadius: 5,
                        pointBorderColor: 'rgba(255, 99, 132)',
                        pointBackgroundColor: 'rgba(255, 99, 132)',
                    },
                ],
            };
            setLineChart(midata);
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    };

    useEffect(() => {
        fetchData(); // Llamada inicial para obtener datos
        const interval = setInterval(fetchData, 3000); // Intervalo de 5 segundos para obtener nuevos datos
        return () => clearInterval(interval); // Limpiar el intervalo al desmontar el componente
    }, []);

    return (
        <>
            <h1 className="bg-info text-center font-monospace fw-bold lh-base">Gráficas ChartJS</h1>
            <p className="m-2">Gráfico de líneas Temperatura</p>
            <div className="bg-light mx-auto px-2 border border-2 border-primary" style={{width:"450px", height:"230px"}}>
                {/* <LinesChart /> */}
                {
                    lineChart != null ?
                        <LinesChart chartData={lineChart} />
                        : "cargando"
                }
            </div>
        
        </>
    )
}