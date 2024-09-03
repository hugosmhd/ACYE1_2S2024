import proyecto1Api from "../../api/proyecto1";

export const EncenderPage = () => {

  const onEncender = async() => {
    const { data } = await proyecto1Api.get('/led/on');
    console.log(data);
    
  }

  return (
    <>
      <h1>Encender Led</h1>
      <hr />

      <button className="btn btn-primary" onClick={onEncender}>Encender Led</button>
    </>
  )
}
