import axios from 'axios';

const proyecto1Api = axios.create({
    baseURL: import.meta.env.VITE_API_URL
});

export default proyecto1Api;