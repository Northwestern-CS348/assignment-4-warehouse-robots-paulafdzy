(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )


  (:action robotMove
      :parameters (?li - location ?lf - location ?r - robot)
      :precondition (and (no-robot ?lf) (not (no-robot ?li)) (connected ?lf ?li))
      :effect (and (no-robot ?li) (not (no-robot ?lf)))
   )


   (:action robotMoveWithPallette
      :parameters (?li - location ?lf - location ?r - robot ?p - pallette)
      :precondition (and (no-robot ?lf) (not (no-robot ?li)) (connected ?lf ?li) (has ?r ?p) (not (no-pallette ?li)) (no-pallette ?lf)) 
      :effect (and (no-robot ?li) (not (no-robot ?lf)) (not (no-pallette ?lf)) (no-pallette ?li))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (packing-location ?l) (packing-at ?s ?l) (started ?s) (not (complete ?s)) (orders ?o ?si) (ships ?s ?o) (contains ?p ?si) (not (no-robot ?l)))
      :effect (and (includes ?s ?si) (not (contains ?p ?si))))
  

   (:action completeShipment
      :parameters (?s - shipment ?l - location ?o - order)
      :precondition (and (started ?s) (ships ?s ?o) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (available ?l) (complete ?s)) 
   )

)
