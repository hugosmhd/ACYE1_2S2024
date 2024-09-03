import proyecto1Api from "../../api/proyecto1";

export const ApagarPage = () => {

  const onApagar = async() => {
    const { data } = await proyecto1Api.get('/led/off');
    console.log(data);
    
  }

  return (
    <>
      <h1>Apagar Led</h1>
      <hr />

      <button className="btn btn-danger" onClick={onApagar}>Apagar Led</button>
    </>
  )
}
